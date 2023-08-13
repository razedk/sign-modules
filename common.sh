#!/bin/bash

# Variables
public_key_file=$keys_folder/public_key.der
private_key_file=$keys_folder/private_key.priv

keys_exist() {
  if [[ -f $public_key_file && -f $private_key_file ]]; then
    echo "true"
  else
    echo "false"
  fi
}

