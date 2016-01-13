#!/bin/bash

set -x
# in this script we will sum up all the different steps to run the tests
# on a mac VM from a mac host
SCRIPT_LOCATION=$(cd "$(dirname "$0")"; pwd)
cd "$SCRIPT_LOCATION"

testee_url=$1
package_name=$2
source_name=$3
osx_name=$4  # might be yosemite, el_capitan, etc.
setup_script=$5
run_script=$6
client_package_url="$testee_url/$package_name"
source_tarball_url="$testee_url/$source_name"

# Step 0: check the things are there
which vagrant                           || echo "Vagrant is not installed!"
vagrant plugin list | grep vagrant-scp  || echo "Vagrant scp plugin not installed!"

# Step 1: boot the VM
vagrant up $osx_name || echo "Cannot execute vagrant up $osx_name"

# Step 2: download and decompress the sources and install the client
vagrant ssh -c "wget $source_tarball_url && tar xvf $source_name && mv cvmfs* cvmfs" $osx_name || echo "Couldn't download and decompress the sources in the mac VM"
vagrant ssh -c "wget $client_package_url && cd / && sudo /usr/sbin/installer -pkg /Users/vagrant/$package_name -target /" $osx_name || echo "Couldn't download and install the CVMFS package"

# Step 3: run the setup script
vagrant ssh -c "cvmfs/test/cloud_testing/platforms/$setup_script" $osx_name

# Step 4: run the test script
vagrant ssh -c "cvmfs/test/cloud_testing/platforms/$run_script" $osx_name

# Step 5: destroy the VM
#vagrant destroy -f $osx_name
