#!/bin/bash

export SDKROOT=$(xcrun --sdk macosx${MACOSX_BUILD_SDK} --show-sdk-path)

rpath_enabled() {
    [ "${RPATH_ENABLE:-1}" != "0" ]
}

_relpath() {
    perl -MFile::Spec -MCwd=realpath \
         -e 'print File::Spec->abs2rel(realpath($ARGV[1]), realpath($ARGV[0]))' \
         "$1" "$2"
}

_loader_rpath() {
    local rel
    rel=$(_relpath "$(dirname "$1")" "$2") || return 1
    if [ "$rel" = "." ]; then
        echo "@loader_path"
    else
        echo "@loader_path/${rel}"
    fi
}

_has_rpath() {
    otool -l "$1" | awk '/cmd LC_RPATH/ { getline; getline; print $2 }' | grep -qxF "$2"
}

_add_rpath() {
    _has_rpath "$1" "$2" && return 0
    install_name_tool -add_rpath "$2" "$1"
}

_is_linkable_macho() {
    file -b "$1" | grep -Eq 'Mach-O.*(executable|dynamically linked shared library|bundle)'
}

# autotools_post_install PREFIX
#
# Arguments:
#   PREFIX  install directory (same as for setup_autotools)
#
# With rpath:
#   1. switches install names of the dylibs of PREFIX/lib (recursively) to @rpath/
#   2. updates references in every Mach-O of PREFIX (lib/, bin/, libexec/,
#      plugins/, qml/...)
#   3. adds to EVERY binary (executables, dylibs, bundles) a relative rpath
#      to PREFIX/lib, so that @rpath dependencies between libraries of the
#      same package (libmpi -> libopen-pal, libpmix, libhwloc...) resolve
#      whatever the consumer
#   4. for each @rpath dependency not found in PREFIX/lib, looks it up in
#      the other packages (${RPATH_SEARCH_ROOT:-dirname PREFIX}/*/lib) and
#      adds a relative rpath to it (e.g. hdf5 -> ../../openmpi/lib)
#   5. adds -Wl,-rpath,${libdir} to the MPI compiler wrappers (mpicc, mpicxx...)
#      so that everything linked with them (ParaView, MEDCoupling...) finds
#      the libraries of PREFIX at run time, including tools run during the build
#   6. re-signs
# Without rpath (RPATH_ENABLE=0): does nothing, libtool already installs
# absolute install names.

autotools_post_install() {
    if [ $# -ne 1 ]; then
        echo "usage: autotools_post_install PREFIX" >&2
        return 1
    fi

    if ! rpath_enabled; then
        return 0
    fi

    if [ ! -d "$1" ]; then
        echo "autotools_post_install: $1 not found" >&2
        return 1
    fi

    local prefix libdir has_libdir=0 search_root
    prefix=$(cd "$1" && pwd -P) || return 1
    libdir="${prefix}/lib"
    [ -d "${libdir}" ] && has_libdir=1
    search_root="${RPATH_SEARCH_ROOT:-$(dirname "${prefix}")}"

    local mach_O_list=() f
    while IFS= read -r -d '' f; do
        _is_linkable_macho "$f" && mach_O_list+=("$f")
    done < <(find "${prefix}" -type f \
                  ! -path "${prefix}/share/doc/*" ! -path "${prefix}/include/*" \
                  -print0 2>/dev/null)

    local changes=() old_id new_id
    while IFS= read -r -d '' f; do
        old_id=$(otool -D "$f" | sed -n '2p')
        [ -n "${old_id}" ] || continue
        case "${old_id}" in
            @*) continue ;;   # already relative
        esac
        new_id="@rpath/$(basename "${old_id}")"
        install_name_tool -id "${new_id}" "$f" || return 1
        changes+=(-change "${old_id}" "${new_id}")
    done < <([ ${has_libdir} -eq 1 ] && find "${libdir}" -type f -name '*.dylib' -print0)

    if [ ${#changes[@]} -gt 0 ]; then
        for f in "${mach_O_list[@]}"; do
            install_name_tool "${changes[@]}" "$f" 2>/dev/null
        done
    fi

    local dep name dir rp
    for f in "${mach_O_list[@]}"; do
        if [ ${has_libdir} -eq 1 ]; then
            rp=$(_loader_rpath "$f" "${libdir}") || return 1
            _add_rpath "$f" "$rp" || return 1
        fi

        while IFS= read -r dep; do
            name=${dep#@rpath/}
            [ -e "${libdir}/${name}" ] && continue
            dir=$(ls -d "${search_root}"/*/lib/"${name}" 2>/dev/null | head -1)
            if [ -z "${dir}" ]; then
                echo "autotools_post_install: warning: ${dep} (needed by ${f#${prefix}/}) not found under ${search_root}/*/lib" >&2
                continue
            fi
            rp=$(_loader_rpath "$f" "$(dirname "${dir}")") || return 1
            _add_rpath "$f" "$rp" || return 1
        done < <(otool -L "$f" | awk 'NR > 1 && $1 ~ /^@rpath\// { print $1 }')
    done

    for f in "${prefix}"/share/*/*-wrapper-data.txt; do
        [ -f "$f" ] && [ ! -L "$f" ] || continue
        grep -q '^linker_flags=.*rpath' "$f" && continue
        sed -i '' 's|^linker_flags=.*|& -Wl,-rpath,${libdir}|' "$f" || return 1
    done

    for f in "${mach_O_list[@]}"; do
        codesign -f -s - "$f" 2>/dev/null
    done
}

autotools_post_install ${PRODUCT_INSTALL}
