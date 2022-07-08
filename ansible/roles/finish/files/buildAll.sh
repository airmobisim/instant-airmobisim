#!/bin/bash
echo "This script builds OMNeT++, SUMO, Veins, AirMobiSim and AirMobiSim_libveins. This step is required."
read -p "Continue?" 


source /home/airmobisim/.bashrc

# Build OMNeT++
cd /home/airmobisim/src/omnetpp
source setenv
./configure

make -j$(( $(nproc) - 1 ))


# Build SUMO
cd /home/airmobisim/src/sumo
export SUMO_HOME="$PWD"
mkdir build/cmake-build && cd build/cmake-build
cmake ../..
make -j$(( $(nproc) - 1 ))


# Build Veins
cd /home/airmobisim/src/veins
./configure
make -j$(( $(nproc) - 1 ))


# Import Veins into Workspace
xvfb-run ~/src/omnetpp/ide/omnetpp -data ~/workspace.omnetpp -nosplash -application org.eclipse.cdt.managedbuilder.core.headlessbuild -import .

# Import Veins_INET into Workspace
#cd /home/airmobisim/src/veins/subprojects/veins_inet
#xvfb-run ~/src/omnetpp/ide/omnetpp -data ~/workspace.omnetpp -nosplash -application org.eclipse.cdt.managedbuilder.core.headlessbuild -import .

# Build AirMobiSim
cd /home/airmobisim/src/
rm -rf AirMobiSim_libveins
rm -rf AirMobiSim
git clone --branch veins-5.2 https://github.com/sommer/veins.git veins
git clone --branch v0.1 https://git.cms-labs.org/git/hardes/AirMobiSim_libveins
git clone --branch v0.1 https://git.cms-labs.org/git/hardes/AirMobiSim.git
#git clone --branch v0.1 https://github.com/airmobisim/AirMobiSim_libveins
#git clone --branch v0.1 https://github.com/airmobisim/AirMobiSim.git

# Import AirMobiSim_libveins into Workspace
cd /home/airmobisim/src/AirMobiSim_libveins
xvfb-run ~/src/omnetpp/ide/omnetpp -data ~/workspace.omnetpp -nosplash -application org.eclipse.cdt.managedbuilder.core.headlessbuild -import .

cd /home/airmobisim/src/AirMobiSim


source setenv
./build.sh -y



# Clean up after installation was successful - Remove buildAll.desktop file
rm -f /home/airmobisim/.config/autostart/buildAll.desktop

echo "Successfully set up the Virtual Machine! You can now start using it."
read -p "Press Enter to proceed." 
