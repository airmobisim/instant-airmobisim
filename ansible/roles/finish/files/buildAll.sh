#!/bin/bash
echo "This script builds OMNeT++, SUMO and AirMobiSim. This step is required."
read -p "Continue?" 
echo "Please wait while OMNeT++, SUMO and AirMobiSim are being built..."

# Build OMNeT++
cd /home/veins/src/omnetpp
source setenv
./configure
make -j${nproc}

# Build SUMO
cd /home/veins/src/sumo
export SUMO_HOME="$PWD"
mkdir build/cmake-build && cd build/cmake-build
cmake ../..
make -j${nproc}

# Build AirMobiSim
cd /home/veins/src/AirMobiSim
./build.sh
