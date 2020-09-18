:: configure
cmake -H"%SRC_DIR%" ^
      -Bbuild ^
      -G"Ninja" ^
      -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%" ^
      -DCMAKE_BUILD_TYPE=Release ^
      -DCMAKE_INSTALL_LIBDIR="%LIBRARY_LIB%" ^
      -DPYMOD_INSTALL_LIBDIR="/../../Lib/site-packages" ^
      -DXCFUN_MAX_ORDER=8 ^
      -DXCFUN_PYTHON_INTERFACE=ON ^
      -DCMAKE_CXX_FLAGS="/wd4018 /wd4101 /wd4996" ^
      -DCMAKE_PREFIX_PATH="%LIBRARY_PREFIX%" ^
      -DCMAKE_INSTALL_INCLUDEDIR="%LIBRARY_INC%" ^
      -DCMAKE_INSTALL_BINDIR="%LIBRARY_BIN%" ^
      -DCMAKE_INSTALL_DATADIR="%LIBRARY_PREFIX%" ^
      -DCMAKE_WINDOWS_EXPORT_ALL_SYMBOLS=true
if errorlevel 1 exit 1

:: build
cd build
cmake --build . ^
      --config Release ^
      -- -j %CPU_COUNT%
if errorlevel 1 exit 1

:: test
:: The Python interface is tested using pytest directly
ctest -E "python-interface" --output-on-failure --verbose
if errorlevel 1 exit 1

:: install
cmake --build . ^
      --config Release ^
      --target install ^
      -- -j %CPU_COUNT%
if errorlevel 1 exit 1
