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

echo ""
echo "Getting LLVM 3.8.0 bin from llvm.org ..."

cd ${INSTALL_DIR}

wget http://llvm.org/releases/3.8.0/clang+llvm-3.8.0-x86_64-linux-gnu-ubuntu-14.04.tar.xz
tar xvf clang+llvm-3.8.0-x86_64-linux-gnu-ubuntu-14.04.tar.xz
