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

export PACKAGE_NAME=gcc-${PACKAGE_VERSION}
export PACKAGE_FILE=${PACKAGE_NAME}.tar.bz2
export PACKAGE_URL=http://fr.mirror.babylon.network/gcc/releases/${PACKAGE_NAME}/${PACKAGE_FILE}
cd ${INSTALL_DIR}

echo ""
echo "In the next step, we will download archive from ${PACKAGE_URL} ..."
echo "However, if you already have it, place it inside this directory:"
echo "${INSTALL_DIR}"
echo ""

read -p "Press [Enter] to continue ..."

if [ ! -f ${PACKAGE_FILE} ]; then

 echo ""
 echo "Downloading archive from ${PACKAGE_URL} ..."
 echo ""

 rm -f ${PACKAGE_FILE}
 wget ${PACKAGE_URL}

 if [ "${?}" != "0" ] ; then
  echo "Error: Downloading failed in $PWD!" 
  exit 1
 fi
fi

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

export INSTALL_OBJ_DIR=${INSTALL_DIR}/obj
rm -rf ${INSTALL_OBJ_DIR}
mkdir $INSTALL_OBJ_DIR

# Glitch with LIBRARY_PATH - has to clean it here
export LIBRARY_PATH=""

MACHINE=$(uname -m)
EXTRA_CFG=""
EXTRA_CFG1="--disable-multilib --enable-shared --enable-static --enable-cloog-backend=isl --disable-cloog-version-check --enable-libgomp --enable-lto --enable-graphite"

if [ "${MACHINE}" == "armv7l" ]; then
  # I didn't manage to compile it properly on RPi - need to fix it ...
  EXTRA_CFG="--disable-libmudflap --enable-libgomp --disable-bootstrap"
  EXTRA_CFG1=""
elif [ "${MACHINE}" == "aarch64" ]; then
  EXTRA_CFG="--with-cpu=cortex-a53 --with-fpu=neon-fp-armv8 --with-float=hard --build=arm-linux-gnueabihf --host=arm-linux-gnueabihf --target=arm-linux-gnueabihf"
  EXTRA_CFG1=""
else:
  export LIBRARY_PATH=/usr/lib/x86_64-linux-gnu
fi

##################################################################################
echo ""
echo "Configuring ..."

cd ${INSTALL_OBJ_DIR}
../${PACKAGE_NAME}/configure --prefix=${INSTALL_DIR} ${EXTRA_CFG}\
                             --enable-languages=c ${EXTRA_CFG1} \
                             --with-gmp=${CK_ENV_LIB_GMP} \
                             --with-mpfr=${CK_ENV_LIB_MPFR} \
                             --with-mpc=${CK_ENV_LIB_MPC} \
                             --with-isl=${CK_ENV_LIB_ISL} \
                             --with-cloog=${CK_ENV_LIB_CLOOG}

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
