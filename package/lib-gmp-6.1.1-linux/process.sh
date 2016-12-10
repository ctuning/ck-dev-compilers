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

PACKAGE_NAME=gmp-6.1.1
PACKAGE_NAME1=${PACKAGE_NAME}
PACKAGE_NAME2=${PACKAGE_NAME}.tar.bz2

cd ${INSTALL_DIR}

rm -f ${PACKAGE_NAME2}
wget https://gmplib.org/download/gmp/${PACKAGE_NAME2}

rm ${PACKAGE_NAME1}.tar
bzip2 -d ${PACKAGE_NAME2}

tar xvf ${PACKAGE_NAME1}.tar
rm ${PACKAGE_NAME1}.tar

export INSTALL_OBJ_DIR=${INSTALL_DIR}/obj
rm -rf ${INSTALL_OBJ_DIR}
mkdir $INSTALL_OBJ_DIR

 echo ""
 cd ${INSTALL_OBJ_DIR}
 ../${PACKAGE_NAME}/configure --prefix=${INSTALL_DIR} --enable-cxx
 if [ "${?}" != "0" ] ; then
   echo "Error: Configuration failed in $PWD!"
   exit 1
 fi

 # Build
 echo ""
 echo "Building ..."
 echo ""
 cd ${INSTALL_OBJ_DIR}
 make $pj
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

