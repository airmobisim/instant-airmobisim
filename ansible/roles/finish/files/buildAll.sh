#!/bin/bash
echo "This script builds OMNeT++, SUMO and AirMobiSim. This step is required."
read -p "Continue?" 
echo "Please wait while OMNeT++, SUMO and AirMobiSim are being built..."

# Build OMNeT++
cd /home/airmobisim/src/omnetpp
source setenv
./configure
make -j${nproc}

# Build SUMO
cd /home/airmobisim/src/sumo
export SUMO_HOME="$PWD"
mkdir build/cmake-build && cd build/cmake-build
cmake ../..
make -j${nproc}

# Build Veins
cd /home/airmobisim/src/veins
./configure
make -j${nproc}

# Import Veins into Workspace
xvfb-run ~/src/omnetpp/ide/omnetpp -data ~/workspace.omnetpp -nosplash -application org.eclipse.cdt.managedbuilder.core.headlessbuild -import .

# Import Veins_INET into Workspace
cd /home/airmobisim/src/veins/subprojects/veins_inet
xvfb-run ~/src/omnetpp/ide/omnetpp -data ~/workspace.omnetpp -nosplash -application org.eclipse.cdt.managedbuilder.core.headlessbuild -import .

# Build AirMobiSim
cd /home/airmobisim/src/airmobisimVeins
git pull
cd /home/airmobisim/src/AirMobiSim
git pull
./build.sh

# Clean up after installation was successful - Remove buildAll.desktop file
rm -f /home/airmobisim/.config/autostart/buildAll.desktop

echo "Successfully set up the Virtual Machine! You can now start using it."
