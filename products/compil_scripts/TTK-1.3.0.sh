#!/bin/bash                                                                                                                                                                              

echo "##########################################################################"
echo "TTK" $VERSION
echo "##########################################################################"

LINUX_DISTRIBUTION="$DIST_NAME$DIST_VERSION"

CMAKE_OPTIONS=""
CMAKE_OPTIONS+=" -DCMAKE_INSTALL_PREFIX:STRING=${PRODUCT_INSTALL}"
CMAKE_OPTIONS+=" -DCMAKE_INSTALL_LIBDIR:STRING=lib"

if [ -n "$SAT_DEBUG" ]; then
    CMAKE_OPTIONS+=" -DCMAKE_BUILD_TYPE:STRING=Debug"
else
    CMAKE_OPTIONS+=" -DCMAKE_BUILD_TYPE:STRING=Release"
fi

CMAKE_OPTIONS+=" -DBUILD_SHARED_LIBS:BOOL=ON"
CMAKE_OPTIONS+=" -DTTK_BUILD_STANDALONE_APPS:BOOL=FALSE" # trimmed folder
CMAKE_OPTIONS+=" -DCMAKE_INSTALL_LIBDIR:PATH=lib"
CMAKE_OPTIONS+=" -DCMAKE_INSTALL_NAME_DIR:PATH=${PRODUCT_INSTALL}/lib"
CMAKE_OPTIONS+=" -DCMAKE_INSTALL_RPATH:STRING=$PRODUCT_INSTALL"
CMAKE_OPTIONS+=" -DTTK_INSTALL_PLUGIN_DIR:PATH=${PARAVIEW_PLUGINS_DIR}"

CMAKE_OPTIONS+=" -DTTK_ENABLE_KAMIKAZE:BOOL=TRUE"
CMAKE_OPTIONS+=" -DTTK_ENABLE_CPU_OPTIMIZATION:BOOL=FALSE"
CMAKE_OPTIONS+=" -DTTK_ENABLE_DOUBLE_TEMPLATING:BOOL=OFF" # save ressources for CI
CMAKE_OPTIONS+=" -DTTK_ENABLE_EIGEN:BOOL=ON"
CMAKE_OPTIONS+=" -DTTK_ENABLE_EMBREE:BOOL=ON"
CMAKE_OPTIONS+=" -DTTK_ENABLE_GRAPHVIZ:BOOL=ON"
CMAKE_OPTIONS+=" -DTTK_ENABLE_OPENMP:BOOL=ON"
CMAKE_OPTIONS+=" -DTTK_ENABLE_MPI:BOOL=ON"
CMAKE_OPTIONS+=" -DTTK_ENABLE_SCIKIT_LEARN:BOOL=OFF"
CMAKE_OPTIONS+=" -DTTK_ENABLE_ZFP:BOOL=OFF"

CMAKE_OPTIONS+=" -DTTK_WHITELIST_MODE:BOOL=TRUE"

ttk_module_settings=(
  # core modules
  ttkAlgorithm
  ttkTriangulationAlgorithm
  ttkProgramBase

  # testing
  ttkHelloWorld
  ttkTriangulationManager
  ttkTriangulationRequest

  # utility
  ttkArrayEditor
  ttkArrayPreconditioning
  ttkBlockAggregator
  ttkExtract
  ttkFlattenMultiBlock
  ttkForEach
  ttkEndFor
  ttkGridLayout
  ttkIcosphere
  ttkIcosphereFromObject
  ttkIcospheresFromPoints
  ttkIdentifierRandomizer
  ttkIdentifyByScalarField
  ttkPeriodicGhostsGeneration # dep for ttkTriangulationManager
  ttkPointDataSelector
  ttkScalarFieldNormalizer
  ttkScalarFieldSmoother
  ttkTextureMapFromField

  # topology
  ttkContinuousScatterPlot
  ttkContourAroundPoint
  ttkContourTree
  ttkContourTreeAlignment
  ttkFiber
  ttkFiberSurface
  ttkIntegralLines
  ttkJacobiSet
  ttkMergeTree
  # ttkMergeTreeAutoencoder   # need pytorch
  # ttkMergeTreeAutoencoderDecoding # need pytorch
  ttkMergeTreePrincipalGeodesics
  ttkMergeTreePrincipalGeodesicsDecoding
  ttkMergeTreePrincipalGeodesicsDecoding_PathTrees
  ttkMergeTreePrincipalGeodesicsDecoding_Surface
  ttkMergeTreeTemporalReduction
  ttkMergeTreeTemporalReductionDecoding
  ttkMeshGraph
  ttkMorseSmaleComplex
  ttkPathCompression
  ttkPersistenceCurve
  ttkPersistenceDiagram
  ttkPersistentGenerators
  ttkPlanarGraphLayout
  ttkReebGraph
  ttkReebSpace
  ttkRipsComplex
  ttkScalarFieldCriticalPoints
  ttkTopologicalSimplification
  ttkTopologicalSimplificationByPersistence
  ttkTrackingFromPersistenceDiagrams # dep for ttkTrackingFromFields
  ttkTrackingFromFields
  ttkTrackingFromOverlap

  # geometry processing
  ttkBottleneckDistance # dep for ttkTrackingFromPersistenceDiagrams
  ttkDepthImageBasedGeometryApproximation
  ttkDistanceField
  ttkGeometrySmoother
  ttkManifoldCheck
  ttkMarchingTetrahedra
  ttkMorseSmaleQuadrangulation
  ttkPointSetToCurve
  ttkPointSetToSurface
  ttkProjectionFromField
  ttkQuadrangulationSubdivision
  ttkSignedDistanceField
  ttkSurfaceGeometrySmoother

  # clustering
  ttkLDistanceMatrix
  ttkMatrixToHeatMap
  ttkMergeTreeClustering
  ttkMergeTreeDistanceMatrix
  ttkPersistenceDiagramClustering
  ttkPersistenceDiagramDistanceMatrix

  # ensemble
  ttkMandatoryCriticalPoints
  ttkDimensionReduction # no sklearn available, only TopoMap

  # cinema
  ttkCinemaReader
  ttkCinemaWriter
  ttkCinemaQuery
  ttkCinemaImaging
  ttkCinemaProductReader

  # compression
  ttkTopologicalCompressionWriter # dependency for ttkCinemaWriter
  ttkTopologicalCompressionReader # going with the writer...

  # darkroom
  ttkDarkroomCamera
  ttkDarkroomColorMapping
  ttkDarkroomCompositing
  ttkDarkroomFXAA
  ttkDarkroomIBS
  ttkDarkroomSSAO
  ttkDarkroomSSDoF
  ttkDarkroomSSSAO

  # table
  ttkDataSetToTable
  ttkMergeBlockTables
  ttkProjectionFromTable
  ttkTableDataSelector
  ttkTableDistanceMatrix

  # web scocket related, disabled because of missing dependency
  # ttkWebSocketIO
  # ttkWebSocketIO
)

for ttk_module in "${ttk_module_settings[@]}"; do
  #echo "$ttk_module"
  CMAKE_OPTIONS+=" -DVTK_MODULE_ENABLE_${ttk_module}:STRING=YES"
done

echo
echo "*** cmake" $CMAKE_OPTIONS
rm -rf $BUILD_DIR
mkdir -p $BUILD_DIR
cd  $BUILD_DIR
cmake $CMAKE_OPTIONS $SOURCE_DIR
if [ $? -ne 0 ]
then
    echo "ERROR on cmake"
    exit 1
fi

echo
echo "*** make" $MAKE_OPTIONS
make $MAKE_OPTIONS
if [ $? -ne 0 ]
then
    echo "ERROR on make"
    exit 2
fi

echo
echo "*** make install"
make install
if [ $? -ne 0 ]
then
    echo "ERROR on make install"
    exit 3
fi

echo
echo "########## END"
