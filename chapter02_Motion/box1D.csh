#!/bin/tcsh -f 

set L  = 10
set xv = (0 1.0)        # x0 v0
set ts = (0 100 1)   # t0 tf dt

foreach n (1 2 3)
 echo "-------------------------"
 echo "Running box1D${n}: "
 gfortran box1D_${n}.f90 -o box$n
 ./box$n <<EOF
$L   L
$xv  x0 v0
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
