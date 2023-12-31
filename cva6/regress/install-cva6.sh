# Copyright 2021 Thales DIS design services SAS
#
# Licensed under the Solderpad Hardware Licence, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# SPDX-License-Identifier: Apache-2.0 WITH SHL-2.0
# You may obtain a copy of the License at https://solderpad.org/licenses/
#
# Original Author: Jean-Roch COULON - Thales

# Customise this to a fast local disk
export ROOT_PROJECT=$(cd "$(dirname "${BASH_SOURCE[0]}")/../../" && pwd)
export TOP="$ROOT_PROJECT/tools"

# where to install the tools
if ! [ -n "$RISCV" ]; then
  echo "Error: RISCV variable undefined."
  return
fi

# Set up tool-related variables.
export PATH="$RISCV/bin:$PATH"
export LIBRARY_PATH="$RISCV/lib"
export LD_LIBRARY_PATH="$RISCV/lib:$LD_LIBRARY_PATH"
export C_INCLUDE_PATH="$RISCV/include"
export CPLUS_INCLUDE_PATH="$RISCV/include"

# Install Verilator v5.
# Set VERILATOR_INSTALL_DIR to 'NO' to skip installation and checks
# of Verilator (useful for CI jobs not depending on Verilator in any way).
if [ "$VERILATOR_INSTALL_DIR" != "NO" ]; then
  cva6/regress/install-verilator.sh

  # Complain if the installation directory of Verilator still is not set
  # after running the installer.
  if [ -z "$VERILATOR_INSTALL_DIR" ]; then
    echo "Error: VERILATOR_INSTALL_DIR variable still undefined after running Verilator installer."
    return
  fi

  # Verilator was set up: add Verilator paths to appropriate variables.
  export PATH="$VERILATOR_INSTALL_DIR/bin:$PATH"
  export C_INCLUDE_PATH="$VERILATOR_INSTALL_DIR/share/verilator/include:$C_INCLUDE_PATH"
  export CPLUS_INCLUDE_PATH="$VERILATOR_INSTALL_DIR/share/verilator/include:$CPLUS_INCLUDE_PATH"

  # Check proper Verilator installation given current $PATH.
  echo PATH=\"$PATH\"
  echo "Verilator version:"
  verilator --version || { echo "Error: Verilator not in \$PATH." ; return ; }
else
  echo "Skipping Verilator setup on user's request (\$VERILATOR_INSTALL_DIR = \"NO\")."
fi

# number of parallel jobs to use for make commands and simulation
export NUM_JOBS=24

# install the required tools for cva6
if ! [ -n "$CVA6_REPO" ]; then
  CVA6_REPO="https://github.com/openhwgroup/cva6.git"
  CVA6_BRANCH="master"
  CVA6_HASH="4f06aa620f75bcae369f05d0652283d45ef76a24"
  CVA6_PATCH=
fi
echo $CVA6_REPO
echo $CVA6_BRANCH
echo $CVA6_HASH
echo $CVA6_PATCH

if ! [ -d core-v-cores/cva6 ]; then
  git clone --recursive $CVA6_REPO -b $CVA6_BRANCH core-v-cores/cva6
  cd core-v-cores/cva6; git checkout $CVA6_HASH;
  echo -n "Using CVA6 commit "; git describe --always HEAD
  if [ -f ../$CVA6_PATCH ]; then
    git apply ../$CVA6_PATCH
  fi
  cd -
fi

# install Spike
if ! [ -n "$SPIKE_ROOT" ]; then
  export SPIKE_ROOT=$TOP/spike/
fi
cva6/regress/install-spike.sh
