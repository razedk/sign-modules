#!/bin/bash

source common.sh

keys_folder=/var/lib/dkms
public_key_file=$keys_folder/mok.pub
private_key_file=$keys_folder/mok.key

kernel_script_folder=/usr/src/kernels/$(uname -r)/scripts

# Check if module has been specified
if [ -z "$1" ]
then
  echo "You need to specify the name of a module to sign"
  echo "Modules are typically found in /lib/modules/<kernel_name>/extra or /usr/lib/modules/<kernel_name>/extra"
  echo ""
  echo "Example: $0 /usr/lib/modules/6.4.6-200.fc38.x86_64/extra/evdi.ko.xz"
  exit 1
fi

# Check if module exist
module_name=$1
if [ ! -f $module_name ]; then
  echo Module $module_name not found
  exit 2
fi

if [[ $module_name == *.xz ]]; then
  echo Module is compressed, will uncompress, sign and compress
  compressed="true";
  compressed_module_name=$module_name
  module_name=${module_name:0:-3}
fi

# Test to ensure signing keys exist
if $(keys_exist) == "true"; then

  if [[ $compressed == "true" ]]; then
    echo Decompressing module $compressed_module_name
    sudo unxz $compressed_module_name
  fi

  echo Signing module $module_name
  sudo $kernel_script_folder/sign-file sha256 $private_key_file $public_key_file $module_name
  
  if [[ $compressed == "true" ]]; then
    echo Compressing module $module_name
    sudo xz $module_name
  fi
else
  echo No signing keys were found. Please run create_keys.sh first to create keys.
  exit 3
fi


