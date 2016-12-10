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


read -p "Enter gcc version (for example, 6.1.0): " gcc_ver

export PACKAGE_NAME=gcc-$gcc_ver
export PACKAGE_FILE=${PACKAGE_NAME}.tar.bz2
export PACKAGE_URL=http://fr.mirror.babylon.network/gcc/releases/${PACKAGE_NAME}/${PACKAGE_FILE}

cd ${INSTALL_DIR}

rm -f ${PACKAGE_FILE}

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

# TBD: need to check that X86 and not ARM ...
export LIBRARY_PATH=/usr/lib/x86_64-linux-gnu

#if ["$LIBRARY_PATH" -eq ""]
#then
# export LIBRARY_PATH=/usr/lib/x86_64-linux-gnu
#else
# #trick to avoid current path in lib
# export LIBRARY_PATH=""
# /usr/lib/x86_64-linux-gnu:${LIBRARY_PATH}/usr/lib/x86_64-linux-gnu
#fi

#
echo ""
echo "Configuring ..."

cd ${INSTALL_OBJ_DIR}
../${PACKAGE_NAME}/configure --prefix=${INSTALL_DIR} \
                             --enable-languages=c,c++,fortran \
                             --disable-multilib \
                             --enable-libgomp \
                             --enable-lto \
                             --enable-shared \
                             --enable-static \
                             --enable-graphite

if [ "${?}" != "0" ] ; then
  echo "Error: Configuration failed in $PWD!"
  exit 1
fi

# Build
echo ""
echo "Building ..."
echo ""
cd ${INSTALL_OBJ_DIR}
make -j1
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
