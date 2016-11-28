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

export OBJ_DIR=${INSTALL_DIR}/obj

cd ${INSTALL_DIR}
mkdir src

echo ""
echo "Downloading LLVM 3.9.0 from llvm.org ..."

if [ "${CK_SKIP_PACKAGE_DOWNLOAD}" != "YES" ] ; then 
  wget ${PACKAGE_URL}/${PACKAGE_VERSION}/llvm-${PACKAGE_VERSION}.src.tar.xz
  tar xvf llvm-${PACKAGE_VERSION}.src.tar.xz

  cd llvm-${PACKAGE_VERSION}.src/tools

  wget ${PACKAGE_URL}/${PACKAGE_VERSION}/cfe-${PACKAGE_VERSION}.src.tar.xz
  tar xvf cfe-${PACKAGE_VERSION}.src.tar.xz
  rm -rf clang
  mv cfe-${PACKAGE_VERSION}.src clang

  wget ${PACKAGE_URL}/${PACKAGE_VERSION}/openmp-${PACKAGE_VERSION}.src.tar.xz
  tar xvf openmp-${PACKAGE_VERSION}.src.tar.xz
  rm -rf openmp
  mv openmp-${PACKAGE_VERSION}.src openmp

  wget ${PACKAGE_URL}/${PACKAGE_VERSION}/polly-${PACKAGE_VERSION}.src.tar.xz
  tar xvf polly-${PACKAGE_VERSION}.src.tar.xz
  rm -rf polly
  mv polly-${PACKAGE_VERSION}.src polly
fi

echo ""
echo "Cleaning ..."

rm -rf $OBJ_DIR
mkdir $OBJ_DIR
cd $OBJ_DIR

echo ""
echo "Configuring ..."

cmake ../llvm-${PACKAGE_VERSION}.src
if [ "$?" != "0" ]; then
 echo "Error: failed configuring ..."
 read -p "Press any key to continue!"
 exit $?
fi


echo ""
echo "Building ..."

cd $OBJ_DIR
cmake --build .
if [ "$?" != "0" ]; then
 echo "Error: failed making ..."
 read -p "Press any key to continue!"
 exit $?
fi

echo ""
echo "Installing ..."

cmake -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR} -P cmake_install.cmake
if [ "$?" != "0" ]; then
 echo "Error: failed installing ..."
 read -p "Press any key to continue!"
 exit $?
fi
