:: configure
cmake -H"%SRC_DIR%" ^
      -Bbuild ^
      -GNinja ^
      -DCMAKE_INSTALL_PREFIX="%PREFIX%" ^
      -DCMAKE_BUILD_TYPE=Release ^
      -DCMAKE_INSTALL_LIBDIR="Library\lib" ^
      -DPYMOD_INSTALL_LIBDIR="..\..\Lib\site-packages" ^
      -DXCFUN_MAX_ORDER=8 ^
      -DXCFUN_PYTHON_INTERFACE=ON ^
      -DCMAKE_CXX_FLAGS="/wd4018 /wd4101 /wd4996 /EHsc" ^
      -DCMAKE_INSTALL_INCLUDEDIR="Library\include" ^
      -DCMAKE_INSTALL_BINDIR="Library\bin" ^
      -DCMAKE_INSTALL_DATADIR="Library" ^
      -DDEF_INSTALL_CMAKEDIR="Library\share\cmake\XCFun" ^
      -DCMAKE_WINDOWS_EXPORT_ALL_SYMBOLS=true
if errorlevel 1 exit 1

:: build
cd build
cmake --build . ^
      --config Release ^
      -- -j %CPU_COUNT% -v -d stats
if errorlevel 1 exit 1

:: test
:: The Python interface is tested using pytest directly
ctest -E "python-interface" ^
      --output-on-failure ^
      --verbose
if errorlevel 1 exit 1

:: install
cmake --build . ^
      --config Release ^
      --target install
if errorlevel 1 exit 1
