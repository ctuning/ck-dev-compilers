#! /bin/bash

#
# Installation script for CK packages.
#
# See CK LICENSE.txt for licensing details.
# See CK Copyright.txt for copyright details.
#
# Developer(s): Grigori Fursin, 2015
#

# PACKAGE_DIR
# INSTALL_DIR

# Fix number of processes
NP=${CK_HOST_CPU_NUMBER_OF_PROCESSORS}
if [ "${PARALLEL_BUILDS}" != "" ] ; then
  NP=${PARALLEL_BUILDS}
fi

#export PACKAGE_VERSION=7.1.0

export PACKAGE_NAME=gcc-${PACKAGE_VERSION}
export PACKAGE_FILE=${PACKAGE_NAME}.tar.bz2
export PACKAGE_URL=http://fr.mirror.babylon.network/gcc/releases/gcc-${PACKAGE_VERSION}/${PACKAGE_FILE}

cd ${INSTALL_DIR}

rm -f ${PACKAGE_FILE}

echo ""
echo "In the next step, we will download archive from ${PACKAGE_URL} ..."
echo "However, if you already have it, place it inside this directory:"
echo "${INSTALL_DIR}"
echo ""

if [ ! -f ${PACKAGE_FILE} ]; then

 echo ""
 echo "Downloading archive from ${PACKAGE_URL} ..."
 echo ""

 wget ${PACKAGE_URL}

 if [ "${?}" != "0" ] ; then
  echo "Error: Downloading failed in $PWD!" 
  exit 1
 fi
fi

#########################################################
echo ""
echo "Extracting archive ..."
echo ""

bzip2 -d ${PACKAGE_NAME}.tar.bz2
tar xvf ${PACKAGE_NAME}.tar
rm ${PACKAGE_NAME}.tar

if [ "${?}" != "0" ] ; then
 echo "Error: extraction failed in $PWD!" 
 exit 1
fi

if [ "${GCC_COMPILE_CFLAGS}" != "" ] ; then
 export CFLAGS="${GCC_COMPILE_CFLAGS}"
fi

if [ "${GCC_COMPILE_CXXFLAGS}" != "" ] ; then
 export CXXFLAGS="${GCC_COMPILE_CXXFLAGS}"
fi

# GCC version
GCC_VER=`gcc -dumpversion`

# MACHINE 
MACHINE=`gcc -dumpmachine`

# Set special vars
if [ "$LD_LIBRARY_PATH" == "" ] ; then
 export LD_LIBRARY_PATH=/usr/lib/${MACHINE}:/usr/lib/gcc/${MACHINE}/${GCC_VER}
else
 LD_LIBRARY_PATH1=${LD_LIBRARY_PATH}
 if [ "${LD_LIBRARY_PATH: -1}" == ":" ] ; then
   LD_LIBRARY_PATH1=${LD_LIBRARY_PATH: : -1}
 fi
 export LD_LIBRARY_PATH=$LD_LIBRARY_PATH1:/usr/lib/${MACHINE}:/usr/lib/gcc/${MACHINE}/${GCC_VER}
fi

if ["$LIBRARY_PATH" == ""] ; then
 export LIBRARY_PATH=/usr/lib/${MACHINE}:/usr/lib/gcc/${MACHINE}/${GCC_VER}
else
 LIBRARY_PATH1=${LIBRARY_PATH}
 if [ "${LIBRARY_PATH: -1}" == ":" ] ; then
   LIBRARY_PATH1=${LIBRARY_PATH: : -1}
 fi
 export LIBRARY_PATH=$LIBRARY_PATH1:/usr/lib/${MACHINE}:/usr/lib/gcc/${MACHINE}/${GCC_VER}
fi

#########################################################
export INSTALL_OBJ_DIR=${INSTALL_DIR}/obj
rm -rf ${INSTALL_OBJ_DIR}
mkdir $INSTALL_OBJ_DIR

echo ""
echo "Configuring ..."

if [ "${GCC_ENABLE_LANGUAGES}" == "" ] ; then
  export GCC_ENABLE_LANGUAGES=c
fi

XMACHINE=$(uname -m)
EXTRA_CFG=""
if [ "${RPI3}" == "YES" ] || [ "${XMACHINE}" == "aarch64" ] ; then
 EXTRA_CFG="--with-cpu=cortex-a53 --with-fpu=neon-fp-armv8 --with-float=hard  --build=arm-linux-gnueabihf --host=arm-linux-gnueabihf --target=arm-linux-gnueabihf"
fi

if [ "${XMACHINE}" == "armv7l" ] || [ "${XMACHINE}" == "aarch64" ] ; then
 export CFLAGS="$CFLAGS -I/usr/include/${MACHINE}"
 export CXXFLAGS="$CXXFLAGS -I/usr/include/${MACHINE}"
fi

echo ""
echo "* CFLAGS = $CFLAGS"
echo "* CXXFLAGS = $CXXFLAGS"
echo "* EXTRA_CFG = $EXTRA_CFG"
echo ""

cd ${INSTALL_OBJ_DIR}

../${PACKAGE_NAME}/configure --prefix=${INSTALL_DIR} \
 -v --enable-languages=${GCC_ENABLE_LANGUAGES} ${EXTRA_CFG} ${EXTRA_CFG_GCC}

if [ "${?}" != "0" ] ; then
  echo "Error: Configuration failed in $PWD!"
  exit 1
fi

# Build
echo ""
echo "Building ..."
echo ""
cd ${INSTALL_OBJ_DIR}
make -j$NP
if [ "${?}" != "0" ] ; then
  echo "Error: Compilation failed in $PWD!" 
  exit 1
fi

# Install
echo ""
echo "Installing ..."
echo ""

make install
if [ "${?}" != "0" ] ; then
  echo "Error: Compilation failed in $PWD!" 
  exit 1
fi
