#!/bin/bash -e -x

OPT_FLAGS=""

dobuild() {

    ./prepare
    make distclean


    CC="$(xcrun -find -sdk ${SDK} clang)" \
    CXX="$(xcrun -find -sdk ${SDK} clang)" \
    CPP="$(xcrun -find -sdk ${SDK} cpp)"  \
    CFLAGS="${HOST_FLAGS} ${OPT_FLAGS}" \
    CXXFLAGS="${HOST_FLAGS} ${OPT_FLAGS}" \
    OBJC="$(xcrun -find -sdk ${SDK} clang)" \
    OBJCFLAGS="${HOST_FLAGS} ${OPT_FLAGS}" \
    ./configure --prefix=$PREFIX --host=$CHOST --without-readline
    make clean
    make gnuplot
    make gnuplot
}

#cp plot.c gnuplot/src/plot.c
cp patches/command.c gnuplot/src/command.c

PWD=`pwd`

SDK="iphoneos"
ARCH_FLAGS="-arch arm64"
HOST_FLAGS="${ARCH_FLAGS} -miphoneos-version-min=10.0 -isysroot $(xcrun -sdk ${SDK} --show-sdk-path)"
CHOST="arm-apple-darwin"
PREFIX="${PWD}/build/ios/arm64"
mkdir -p $PREFIX

cd gnuplot
dobuild
cp src/gnuplot $PREFIX/gnuplot 
cd ..


SDK="iphonesimulator"
ARCH_FLAGS="-arch i386"
HOST_FLAGS="${ARCH_FLAGS} -miphoneos-version-min=10.0 -isysroot $(xcrun -sdk ${SDK} --show-sdk-path)"
CHOST="i386-apple-darwin"
PREFIX="${PWD}/build/ios/i386"
mkdir -p $PREFIX

cd gnuplot
dobuild
cp src/gnuplot $PREFIX/gnuplot 
cd ..


SDK="iphonesimulator"
ARCH_FLAGS="-arch x86_64"
HOST_FLAGS="${ARCH_FLAGS} -miphoneos-version-min=10.0 -isysroot $(xcrun -sdk ${SDK} --show-sdk-path)"
CHOST="x86_64-apple-darwin"
PREFIX="${PWD}/build/ios/x86_64"
mkdir -p $PREFIX

cd gnuplot
dobuild
cp src/gnuplot $PREFIX/gnuplot 
cd ..

xcrun lipo -create -output "${PWD}/build/ios/gnuplot" "${PWD}/build/ios/arm64/gnuplot" "${PWD}/build/ios/i386/gnuplot" "${PWD}/build/ios/x86_64/gnuplot"
