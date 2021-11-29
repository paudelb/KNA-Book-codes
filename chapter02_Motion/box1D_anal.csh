#!/bin/tcsh -f 

set L   = 10
set x0  = 0.0
set v0  = 1.0
set t0  = 0.0
set tf  = 95
set ns  = (1 2 3 4 5 6) #versions of code
#set dts = (0.1 0.05 0.025 0.0125 0.01 0.005 0.0025 0.00125) 
set dts = (0.050000 0.025000 0.012500 0.006250 0.003125 0.001563 0.000781 0.000391 0.000195 0.000098 0.000049 0.000024 0.000012)
set prog  = `basename $0` # name of this file
set progn = $prog:r       # name of this file without the .csh extension
set log   = $progn.log    # log  file
set dat   = $progn.dat    # data file
# Compile code:
date                                                        >>  $log
echo "#===================================================" >>  $log
foreach n ($ns)
 echo "# Compiling box1D_${n}.f90                         " >>  $log
 gfortran -O3  box1D_${n}.f90 -o box$n                      >>& $log
end

# Run for default values:
foreach dt ( $dts )
 echo "dt = $dt"
 set results = ($tf $dt)         # store each lines of results here
 echo "# Running dt = $dts                               " >>  $log
 foreach n ($ns)
  ./box$n <<EOF >> log
$L
$x0 $v0
$t0 $tf $dt
EOF
  set results = ($results `tail -n 1 box1D_${n}.dat|awk '{print $1,$2}'`)
  \mv -f box1D_${n}.dat box1D_${n}_dt${dt}.dat
 end
 echo $results >> $dat
end
#  ---------------------------------------------------------------------
#  Copyright by Konstantinos N. Anagnostopoulos (2004-2014)
#  Physics Dept., National Technical University,
#  konstant@mail.ntua.gr, www.physics.ntua.gr/~konstant
#  
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, version 3 of the License.
#  
#  This program is distributed in the hope that it will be useful, but
#  WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
#  General Public License for more details.
#  
#  You should have received a copy of the GNU General Public Liense along
#  with this program.  If not, see <http://www.gnu.org/licenses/>.
#  -----------------------------------------------------------------------
