# Generated by vinca http://github.com/seanyen/vinca.
# DO NOT EDIT!

CATKIN_BUILD_BINARY_PACKAGE="ON"

if [ "${PKG_NAME}" == "ros-melodic-catkin" ]; then
    # create catkin cookie to make it is a catkin workspace
    touch $PREFIX/.catkin
    # keep the workspace activation scripts (e.g., local_setup.bat)
    CATKIN_BUILD_BINARY_PACKAGE="OFF"
fi

rm -rf build
mkdir build
cd build

# necessary for correctly linking SIP files (from python_qt_bindings)
export LINK=$CXX

export ROS_PYTHON_VERSION=`python -c "import sys; print('%i.%i' % (sys.version_info[0:2]))"`
echo "Using Python $ROS_PYTHON_VERSION"

# NOTE: there might be undefined references occurring
# in the Boost.system library, depending on the C++ versions
# used to compile Boost. We can avoid them by forcing the use of
# the header-only version of the library.
export CXXFLAGS="$CXXFLAGS -DBOOST_ERROR_CODE_HEADER_ONLY"

cmake .. -DCMAKE_INSTALL_PREFIX=$PREFIX \
         -DCMAKE_PREFIX_PATH=$PREFIX \
         -DCMAKE_BUILD_TYPE=Release \
         -DCMAKE_INSTALL_LIBDIR=lib \
         -DBUILD_SHARED_LIBS=ON \
         -DPYTHON_EXECUTABLE=$(which python) \
         -DSETUPTOOLS_DEB_LAYOUT=OFF \
         -DCATKIN_SKIP_TESTING=ON \
         -DCATKIN_BUILD_BINARY_PACKAGE=$CATKIN_BUILD_BINARY_PACKAGE \
         $SRC_DIR/$PKG_NAME/src/work

make VERBOSE=1 -j${CPU_COUNT}
make install

if [ "${PKG_NAME}" == "ros-melodic-catkin" ]; then
    # Copy the [de]activate scripts to $PREFIX/etc/conda/[de]activate.d.
    # This will allow them to be run on environment activation.
    for CHANGE in "activate" "deactivate"
    do
        mkdir -p "${PREFIX}/etc/conda/${CHANGE}.d"
        cp "${RECIPE_DIR}/${CHANGE}.sh" "${PREFIX}/etc/conda/${CHANGE}.d/${PKG_NAME}_${CHANGE}.sh"
    done
fi