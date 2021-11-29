#!/bin/tcsh -f 
# gnuplot> file  = "Wormhole.dat"
# gnuplot> R=1;d=5;L=20;
# gnuplot> t0=0;dt=1;load "Wormhole_animate.gnu"
# suggested starting parameters:
# set Ls  = (20 5 1   ) # (L,d,R)
# set X0  = (0 -1 1 10) # (x0,y0), v0, theta (degrees)
# set T0  = (40 0.05  ) # tf, dt

set Ls    = (20 5 1   ) # (L,d,R)
set X0    = (0 -1 1 10) # (x0,y0), v0, theta (degrees)
set T0    = (40 0.05  ) # tf, dt
gfortran Wormhole.f90 -o wh
./wh <<EOF
$Ls (L,d,R)
$X0 (x0,y0), v0, theta
$T0 tf, dt
EOF

# stable closed loop:
# set X0    = (0 0 1 0) # (x0,y0), v0, theta (degrees)
# instability: theta = 0 + epsilon
# set X0    = (0 0 1 0.01) # (x0,y0), v0, theta (degrees)
# another closed loop: (due to periodic BC)
# set X0    = (-9 0 1 0.0) # (x0,y0), v0, theta (degrees)
# also unstable:
# set X0    = (-9 0 1 0.01) # (x0,y0), v0, theta (degrees)
# another closed loop:
# set X0    = (2.5 -3 1 90) # (x0,y0), v0, theta (degrees)
# also unstable:
# set X0    = (2.5 -3 1 90.01) # (x0,y0), v0, theta (degrees)

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
