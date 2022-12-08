#!/bin/bash
#
# Copyright (C) 2022 Simon Welzel <simon.welzel@uni-paderborn.de>
# Copyright (C) 2022 Tobias Hardes <tobias.hardes@uni-paderborn.de>
#
# Documentation for these modules is at http://veins.car2x.org/
#
# SPDX-License-Identifier: GPL-2.0-or-later
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#
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

# Build AirMobiSim
cd /home/airmobisim/src/
rm -rf AirMobiSim_libveins
rm -rf AirMobiSim
git clone --branch veins-5.2 https://github.com/sommer/veins.git veins
git clone https://github.com/airmobisim/AirMobiSim_libveins
git clone https://github.com/airmobisim/AirMobiSim.git

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
