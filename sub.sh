#!/bin/bash
#
# Shortest way to terraform a Linux environment as for my taste:
#
#  $ curl sub.sh | bash
#  $ wget -qO- sub.sh | bash
#
set -e

echo $1

# make a sandbox directory.
SANDBOX="$(mktemp -d)"
trap "rm -rf $SANDBOX" EXIT

# ensure that fab exists.
if ! [ -x "$(command -v fab)" ]; then
  virtualenv $SANDBOX/env
  source $SANDBOX/env/bin/activate
  pip install fabric fabtools
fi

# terraform.
FABFILE_URL=https://raw.githubusercontent.com/sublee/subleenv/master/fabfile.py
wget -qP $SANDBOX $FABFILE_URL
fab -f $SANDBOX/fabfile.py -H localhost terraform
