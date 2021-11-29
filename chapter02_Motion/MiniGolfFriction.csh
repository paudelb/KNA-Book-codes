#!/bin/tcsh -f 
set L = (10 5)          # Lx,Ly
set xc = (8 2.5 0.5)    # (xc,yx) R
set v0 = (0.5 10 80)    # k v0 theta
set dt = 0.001          # dt
gfortran MiniGolfFriction.f90 -o mg
./mg <<EOF
$L                        Lx Ly
$xc                       (xc,yc) R
$v0                       v0 theta (degrees)
$dt                       dt
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
