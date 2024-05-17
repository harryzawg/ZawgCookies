@echo off

REM Change to E: drive
E:
cd \

REM Create a directory for the project if it doesn't exist
if not exist E:\project mkdir E:\project
cd E:\project

REM Install dependencies not available with vcpkg
echo Installing some dependencies we need to build
choco install -y cmake git m4 automake bison python3 openssl

REM Install ninja
echo Installing ninja
(
    REM Create a directory for ninja if it doesn't exist
    if not exist E:\ninja mkdir E:\ninja
    cd E:\ninja

    REM Install ninja >=1.10.2 (needed to build Glib)
    git clone https://github.com/ninja-build/ninja
    cd ninja
    cmake -Bbuild-cmake
    cmake --build build-cmake
    copy build-cmake\ninja.exe E:\ninja\ninja.exe
    set PATH=%PATH%;E:\ninja
)

REM Install vcpkg and dependencies
echo Installing vcpkg and dependencies
(
    REM Create a directory for vcpkg if it doesn't exist
    if not exist E:\vcpkg mkdir E:\vcpkg
    cd E:\vcpkg

    REM Clone vcpkg repository
    git clone https://github.com/Microsoft/vcpkg.git E:\vcpkg
    cd E:\vcpkg
    echo set(VCPKG_BUILD_TYPE release) >> triplets\x64-windows.cmake
    bootstrap-vcpkg.bat -disableMetrics
    set VCPKG_FORCE_SYSTEM_BINARIES=1
    vcpkg install libsecret sqlite3 openssl jsoncons argparse --triplet x64-windows
)

REM Configure and compile project
cmake -S . -B build -DCMAKE_TOOLCHAIN_FILE="E:\vcpkg\scripts\buildsystems\vcpkg.cmake" -DCMAKE_BUILD_TYPE=Release
cmake --build build --config Release -- /m