# configure
cmake ${CMAKE_ARGS} \
     -H${SRC_DIR} \
     -Bbuild \
     -GNinja \
     -DCMAKE_INSTALL_PREFIX=${PREFIX} \
     -DCMAKE_BUILD_TYPE=Release \
     -DCMAKE_CXX_COMPILER=${CXX} \
     -DPYTHON_EXECUTABLE=${PYTHON} \
     -DCMAKE_INSTALL_LIBDIR="lib" \
     -DPYMOD_INSTALL_LIBDIR="${SP_DIR#$PREFIX/lib}" \
     -DXCFUN_MAX_ORDER=8 \
     -DXCFUN_PYTHON_INTERFACE=ON

# build
cd build
cmake --build . -- -j${CPU_COUNT}

# test
# The Python interface is tested using pytest directly
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" || "${CROSSCOMPILING_EMULATOR}" != "" ]]; then
ctest -E "python-interface" -j${CPU_COUNT} --output-on-failure --verbose
fi

# install
cmake --build . --target install
