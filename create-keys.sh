#!/bin/bash

source common.sh

keys_folder=keys
config_file=create-keys.ssl

# Test if keys already exist
if $(keys_exist) == "true"; then
  echo Keys already exists, exiting with no action
  echo Please delete keys folder if you want to generate new keys
  exit 1
fi

# Create keys folder (if not already exists)
if [ ! -d $keys_folder ]; then
  mkdir -p $keys_folder;
fi

# Create public and private keys
echo Creating keys, this can take a while 
openssl req -x509 -new -noenc -utf8 -sha256 -days 36500 -batch -config $config_file -outform DER -out $public_key_file -keyout $private_key_file 2>/dev/null 1>/dev/null

# Validate that keys were successfully created
if $(keys_exist) == "true"; then
  printf "Keys successfully created \n\n"
  echo Public key : $public_key_file
  echo Private key: $private_key_file
else
  echo Keys could not be created
fi

# Import public key
echo Importing public key
sudo mokutil --import $public_key_file
if [ "$?" -eq 0 ]; then
  echo Public key imported
else
  echo Public key could not be imported
fi

