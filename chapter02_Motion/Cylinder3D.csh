#!/bin/tcsh -f 

set rl = (10 10 )          # R L
set r0 = (1 2.2 3.1)       # x0,y0,z0
set v0 = (0.93 -0.89 0.74) # v0x v0y v0z
set t0 = (0 500 0.01)      # t0, tf, dt

gfortran Cylinder3D.f90 -o cl 
./cl <<EOF
$rl       R  L
$r0 $v0   x0 y0 z0    v0x v0y v0z
$t0       t0 tf dt
EOF
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
