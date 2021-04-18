#!/usr/bin/env bash
#---------------------------------------------------------------------------------------------
# Version example : 2020 3310100

if [ "$#" -ne 2 ]
then
    echo "Usage:"
    echo "./SQLiteBuilt.sh <YEAR> <VERSION>"
    exit 1
fi

VERSION=$2
YEAR=$1

#---------------------------------------------------------------------------------------------
# Config
#---------------------------------------------------------------------------------------------

SQLITE_CFLAGS=" \
-DSQLITE_THREADSAFE=1 \
-DSQLITE_TEMP_STORE=2 \
"

LDFLAGS="\
"

COMPILE_OPTION=" \
--with-pic \
--disable-tcl \
--enable-tempstore=yes \
--enable-threadsafe=yes \
"

#---------------------------------------------------------------------------------------------
# Download sources
#---------------------------------------------------------------------------------------------
#prepare dir to compile

mkdir ./tmp
mkdir ./tmp/${VERSION}
cd ./tmp/${VERSION}/

#Download sources files from SQLite

curl -OL https://www.sqlite.org/${YEAR}/sqlite-autoconf-${VERSION}.tar.gz
tar -xvf sqlite-autoconf-${VERSION}.tar.gz
ls 
cd sqlite-autoconf-${VERSION}

#---------------------------------------------------------------------------------------------
# for Apple©
#---------------------------------------------------------------------------------------------

DEVELOPER=$(xcode-select -print-path)
TOOLCHAIN_BIN="${DEVELOPER}/Toolchains/XcodeDefault.xctoolchain/usr/bin"
export CC="${TOOLCHAIN_BIN}/clang"
export AR="${TOOLCHAIN_BIN}/ar"
export RANLIB="${TOOLCHAIN_BIN}/ranlib"
export STRIP="${TOOLCHAIN_BIN}/strip"
export LIBTOOL="${TOOLCHAIN_BIN}/libtool"
export NM="${TOOLCHAIN_BIN}/nm"
export LD="${TOOLCHAIN_BIN}/ld"

#---------------------------------------------------------------------------------------------
# iOS (iPhone / iPad)
#---------------------------------------------------------------------------------------------
#Compile for ARMV7

ARCH=armv7
IOS_MIN_SDK_VERSION=10.0
OS_COMPILER="iPhoneOS"
HOST="arm-apple-darwin"

export CROSS_TOP="${DEVELOPER}/Platforms/${OS_COMPILER}.platform/Developer"
export CROSS_SDK="${OS_COMPILER}.sdk"

CFLAGS="\
-fembed-bitcode \
-arch ${ARCH} \
-isysroot ${CROSS_TOP}/SDKs/${CROSS_SDK} \
-mios-version-min=${IOS_MIN_SDK_VERSION} \
"

make clean

./configure ${COMPILE_OPTION} \
--host="$HOST" \
CFLAGS="${CFLAGS} ${SQLITE_CFLAGS}" \
LDFLAGS="${LDFLAGS}"

make

mkdir ./${ARCH}
cp .libs/libsqlite3.a ${ARCH}/libsqlite3.a

#---------------------------------------------------------------------------------------------
#Compile for ARMV7s

ARCH=armv7s
IOS_MIN_SDK_VERSION=10.0
OS_COMPILER="iPhoneOS"
HOST="arm-apple-darwin"

export CROSS_TOP="${DEVELOPER}/Platforms/${OS_COMPILER}.platform/Developer"
export CROSS_SDK="${OS_COMPILER}.sdk"

CFLAGS="\
-fembed-bitcode \
-arch ${ARCH} \
-isysroot ${CROSS_TOP}/SDKs/${CROSS_SDK} \
-mios-version-min=${IOS_MIN_SDK_VERSION} \
"

make clean

./configure ${COMPILE_OPTION} \
--host="$HOST" \
CFLAGS="${CFLAGS} ${SQLITE_CFLAGS}" \
LDFLAGS="${LDFLAGS}"

make

mkdir ./${ARCH}
cp .libs/libsqlite3.a ${ARCH}/libsqlite3.a

#---------------------------------------------------------------------------------------------
#Compile for ARM64

ARCH=arm64
IOS_MIN_SDK_VERSION=10.0
OS_COMPILER="iPhoneOS"
HOST="arm-apple-darwin"

export CROSS_TOP="${DEVELOPER}/Platforms/${OS_COMPILER}.platform/Developer"
export CROSS_SDK="${OS_COMPILER}.sdk"

CFLAGS="\
-fembed-bitcode \
-arch ${ARCH} \
-isysroot ${CROSS_TOP}/SDKs/${CROSS_SDK} \
-mios-version-min=${IOS_MIN_SDK_VERSION} \
"

make clean

./configure ${COMPILE_OPTION} \
--host="$HOST" \
CFLAGS="${CFLAGS} ${SQLITE_CFLAGS}" \
LDFLAGS="${LDFLAGS}"

make

mkdir ./${ARCH}
cp .libs/libsqlite3.a ${ARCH}/libsqlite3.a

#---------------------------------------------------------------------------------------------
#Compile for x86_64

ARCH=x86_64
IOS_MIN_SDK_VERSION=10.0
OS_COMPILER="iPhoneSimulator"
HOST="x86_64-apple-darwin"

export CROSS_TOP="${DEVELOPER}/Platforms/${OS_COMPILER}.platform/Developer"
export CROSS_SDK="${OS_COMPILER}.sdk"

CFLAGS="\
-fembed-bitcode \
-arch ${ARCH} \
-isysroot ${CROSS_TOP}/SDKs/${CROSS_SDK} \
-mios-version-min=${IOS_MIN_SDK_VERSION} \
"

make clean

./configure ${COMPILE_OPTION} \
--host="$HOST" \
CFLAGS="${CFLAGS} ${SQLITE_CFLAGS}" \
LDFLAGS="${LDFLAGS}"

make

mkdir ./${ARCH}
cp .libs/libsqlite3.a ${ARCH}/libsqlite3.a

#---------------------------------------------------------------------------------------------
#LIPO

cd ..
cd ..
cd ..
mkdir ./${VERSION}
mkdir ./${VERSION}/iOS

rm ./${VERSION}/iOS/libsqlite3.a
lipo -create -output "./${VERSION}/iOS/libsqlite3.a" "./tmp/${VERSION}/sqlite-autoconf-${VERSION}/armv7/libsqlite3.a" "./tmp/${VERSION}/sqlite-autoconf-${VERSION}/armv7s/libsqlite3.a" "./tmp/${VERSION}/sqlite-autoconf-${VERSION}/arm64/libsqlite3.a" "./tmp/${VERSION}/sqlite-autoconf-${VERSION}/x86_64/libsqlite3.a"

open ./${VERSION}

File ./${VERSION}/libsqlite3.a

#---------------------------------------------------------------------------------------------

cd ./tmp/${VERSION}/sqlite-autoconf-${VERSION}

#---------------------------------------------------------------------------------------------
# tvOS (Apple TV)
#---------------------------------------------------------------------------------------------
#Compile for ARM64

ARCH=arm64
TVOS_MIN_SDK_VERSION=10.0
OS_COMPILER="AppleTVOS"
HOST="arm-apple-darwin"

export CROSS_TOP="${DEVELOPER}/Platforms/${OS_COMPILER}.platform/Developer"
export CROSS_SDK="${OS_COMPILER}.sdk"

CFLAGS="\
-fembed-bitcode \
-arch ${ARCH} \
-isysroot ${CROSS_TOP}/SDKs/${CROSS_SDK} \
-mtvos-version-min=${TVOS_MIN_SDK_VERSION} \
"

make clean

./configure ${COMPILE_OPTION} \
--host="$HOST" \
CFLAGS="${CFLAGS} ${SQLITE_CFLAGS}" \
LDFLAGS="${LDFLAGS}"

make

mkdir ./${ARCH}
cp .libs/libsqlite3.a ${ARCH}/libsqlite3.a

#---------------------------------------------------------------------------------------------
#Compile for x86_64

ARCH=x86_64
TVOS_MIN_SDK_VERSION=10.0
OS_COMPILER="AppleTVSimulator"
HOST="x86_64-apple-darwin"

export CROSS_TOP="${DEVELOPER}/Platforms/${OS_COMPILER}.platform/Developer"
export CROSS_SDK="${OS_COMPILER}.sdk"

CFLAGS="\
-arch ${ARCH} \
-isysroot ${CROSS_TOP}/SDKs/${CROSS_SDK} \
-mtvos-version-min=${TVOS_MIN_SDK_VERSION} \
"

make clean

./configure ${COMPILE_OPTION} \
--host="$HOST" \
CFLAGS="${CFLAGS} ${SQLITE_CFLAGS}" \
LDFLAGS="${LDFLAGS}"

make

mkdir ./${ARCH}
cp .libs/libsqlite3.a ${ARCH}/libsqlite3.a

#---------------------------------------------------------------------------------------------
#LIPO

cd ..
cd ..
cd ..
mkdir ./${VERSION}
mkdir ./${VERSION}/tvOS

rm ./${VERSION}/tvOS/libsqlite3.a
lipo -create -output "./${VERSION}/tvOS/libsqlite3.a" "./tmp/${VERSION}/sqlite-autoconf-${VERSION}/arm64/libsqlite3.a" "./tmp/${VERSION}/sqlite-autoconf-${VERSION}/x86_64/libsqlite3.a"

open ./${VERSION}

File ./${VERSION}/tvOS/libsqlite3.a

#---------------------------------------------------------------------------------------------

cd ./tmp/${VERSION}/sqlite-autoconf-${VERSION}

#---------------------------------------------------------------------------------------------
# remove export for iOS tvOS
#---------------------------------------------------------------------------------------------
unset CC
unset AR
unset RANLIB
unset STRIP
unset LIBTOOL
unset NM
unset LD
unset CROSS_TOP
unset CROSS_SDK
#---------------------------------------------------------------------------------------------
# macOS (OSX)
#---------------------------------------------------------------------------------------------

CFLAGS=" \
-arch x86_64 \
-mmacos-version-min=10.10 \
"

make clean

./configure ${COMPILE_OPTION} \
CFLAGS="${CFLAGS} ${SQLITE_CFLAGS}" \
LDFLAGS="${LDFLAGS}"

make

#Copy result

cd ..
cd ..
cd .. 

mkdir ./${VERSION}
mkdir ./${VERSION}/macOS
rm  ./${VERSION}/macOS/libsqlite3.0.dylib

cp ./tmp/${VERSION}/sqlite-autoconf-${VERSION}/.libs/libsqlite3.0.dylib ./${VERSION}/macOS/libsqlite3.0.dylib

#---------------------------------------------------------------------------------------------


#---------------------------------------------------------------------------------------------
# Clean all sources and files
#---------------------------------------------------------------------------------------------

rm -r ./tmp

