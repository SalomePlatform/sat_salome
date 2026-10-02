"""Print the direct DLL imports of a PE file (.exe/.dll) — pure stdlib, no deps.

Usage: python show_deps.py <path-to-exe-or-dll>
"""
import struct
import sys


def read_imports(path):
    with open(path, "rb") as f:
        data = f.read()

    # DOS header -> PE header offset at 0x3C
    pe_off = struct.unpack_from("<I", data, 0x3C)[0]
    assert data[pe_off:pe_off + 4] == b"PE\0\0", "not a PE file"

    coff = pe_off + 4
    num_sections = struct.unpack_from("<H", data, coff + 2)[0]
    opt_size = struct.unpack_from("<H", data, coff + 16)[0]
    opt_off = coff + 20

    magic = struct.unpack_from("<H", data, opt_off)[0]
    is_pe32_plus = magic == 0x20B  # PE32+ (64-bit)

    # Data directories start after the fixed optional header
    # PE32: 96 bytes, PE32+: 112 bytes before the data directory array
    dd_off = opt_off + (112 if is_pe32_plus else 96)
    # Import table is data directory index 1
    import_rva = struct.unpack_from("<I", data, dd_off + 8)[0]
    if import_rva == 0:
        return []

    # Build section table to map RVA -> file offset
    sect_off = opt_off + opt_size
    sections = []
    for i in range(num_sections):
        base = sect_off + i * 40
        va = struct.unpack_from("<I", data, base + 12)[0]
        vsize = struct.unpack_from("<I", data, base + 8)[0]
        raw_ptr = struct.unpack_from("<I", data, base + 20)[0]
        sections.append((va, vsize, raw_ptr))

    def rva_to_off(rva):
        for va, vsize, raw_ptr in sections:
            if va <= rva < va + max(vsize, 1) + 0x2000:
                return raw_ptr + (rva - va)
        return None

    names = []
    idt = rva_to_off(import_rva)
    while True:
        # IMAGE_IMPORT_DESCRIPTOR is 20 bytes; name RVA at offset 12
        name_rva = struct.unpack_from("<I", data, idt + 12)[0]
        if name_rva == 0:
            break
        name_off = rva_to_off(name_rva)
        end = data.index(b"\0", name_off)
        names.append(data[name_off:end].decode("ascii", "replace"))
        idt += 20
    return names


if __name__ == "__main__":
    target = sys.argv[1]
    print(f"Direct DLL imports of {target}:\n")
    for name in sorted(read_imports(target), key=str.lower):
        print(f"  {name}")
