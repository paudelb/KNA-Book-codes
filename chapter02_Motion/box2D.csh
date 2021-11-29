#!/bin/tcsh -f 
set L  = (10 5)           # Lx Ly
set xv = (5 0 1.27 1.33)  # x0 y0 v0x v0y
set ts = (0 50 0.01)     # t0 tf dt

foreach n (1 2 3)
 echo "-------------------------"
 echo "Running box2D${n}: "
 gfortran box2D_${n}.f90 -o box$n
 ./box$n <<EOF
$L   Lx Ly
$xv  x0 y0 v0x v0y
$ts  t0 tf dt
EOF
 echo "Done!"
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
