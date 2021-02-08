#!/bin/bash -e -x

OPT_FLAGS=""

dobuild() {
    export CC="$(xcrun -find -sdk ${SDK} clang)"
    export CXX="$(xcrun -find -sdk ${SDK} clang)"
    export CPP="$(xcrun -find -sdk ${SDK} cpp)"
    export AR="$(xcrun -find -sdk ${SDK} ar)"
    export LD="$(xcrun -find -sdk ${SDK} ld)"
    export RANLIB="$(xcrun -find -sdk ${SDK} ranlib)"
    export CFLAGS="${HOST_FLAGS} ${OPT_FLAGS} -I$PREFIX/include"
    export CXXFLAGS="${HOST_FLAGS} ${OPT_FLAGS} -I$PREFIX/include"
    export LDFLAGS="-L${PREFIX}/lib"
    
    ./prepare
    make clean
    ./configure --prefix=$PREFIX --host=$CHOST --target=$CHOST --without-readline
    make gnuplot
    make install prefix=$PREFIX
}

cp command.c gnuplot/src/command.c

PWD=`pwd`

SDK="iphoneos"
ARCH_FLAGS="-arch arm64"
HOST_FLAGS="${ARCH_FLAGS} -miphoneos-version-min=10.0 -isysroot $(xcrun -sdk ${SDK} --show-sdk-path)"
CHOST="arm-apple-darwin"
PREFIX="${PWD}/build/ios/arm64"
mkdir -p $PREFIX

cd gnuplot
dobuild
cd ..

SDK="iphonesimulator"
ARCH_FLAGS="-arch i386"
HOST_FLAGS="${ARCH_FLAGS} -miphoneos-version-min=10.0 -isysroot $(xcrun -sdk ${SDK} --show-sdk-path)"
CHOST="i386-apple-darwin"
PREFIX="${PWD}/build/ios/i386"
mkdir -p $PREFIX

cd gnuplot
dobuild
cd ..


SDK="iphonesimulator"
ARCH_FLAGS="-arch x86_64"
HOST_FLAGS="${ARCH_FLAGS} -miphoneos-version-min=10.0 -isysroot $(xcrun -sdk ${SDK} --show-sdk-path)"
CHOST="x86_64-apple-darwin"
PREFIX="${PWD}/build/ios/x86_64"
mkdir -p $PREFIX

cd gnuplot
dobuild
cd ..

#xcrun lipo -create -output "${PWD}/build/ios/libdcraw.a" "${PWD}/build/ios/arm64/lib/libdcraw.a" "${PWD}/build/ios/i386/lib/libdcraw.a" "${PWD}/build/ios/x86_64/lib/libdcraw.a"
