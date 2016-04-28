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

echo ""
echo "Getting LLVM 3.8.0 from llvm.org ..."

cd ${INSTALL_DIR}
mkdir src

#wget http://llvm.org/releases/3.8.0/llvm-3.8.0.src.tar.xz
#tar xvf llvm-3.8.0.src.tar.xz

cd llvm-3.8.0.src/tools

#wget http://llvm.org/releases/3.8.0/cfe-3.8.0.src.tar.xz
#tar xvf cfe-3.8.0.src.tar.xz
mv cfe-3.8.0.src clang

#wget http://llvm.org/releases/3.8.0/openmp-3.8.0.src.tar.xz
#tar xvf openmp-3.8.0.src.tar.xz
mv openmp-3.8.0.src openmp

#wget http://llvm.org/releases/3.8.0/polly-3.8.0.src.tar.xz
#tar xvf polly-3.8.0.src.tar.xz
mv polly-3.8.0.src polly

echo ""
echo "Configuring ..."

mkdir $OBJ_DIR
cd $OBJ_DIR

cmake ../llvm-3.8.0.src
if [ "$?" != "0" ]; then
 echo "Error: failed configuring ..."
 read -p "Press any key to continue!"
 exit $?
fi


echo ""
echo "Building ..."

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
