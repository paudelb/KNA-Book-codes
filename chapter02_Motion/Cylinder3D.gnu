# Usage:
# R = 10; L= 10; load "Cylinder3D.gnu"
file="Cylinder3D.dat"
set term qt 1
plot file using 1:2 with lines t "x(t)",\
     file using 1:3 with lines t "y(t)",\
     file using 1:4 with lines t "z(t)"

set term qt 2
plot file using 1:(sqrt($2**2+$3**2)) with lines title "r(t)"

set term qt 3
plot file using 1:5 with lines t "v_x(t)",\
     file using 1:6 with lines t "v_y(t)",\
     file using 1:7 with lines t "v_z(t)"

set term qt 4
set urange [0:2.0*pi]
set vrange [0:L]
set parametric
set xlabel "x"
set ylabel "y"
set zlabel "z"
splot file using 2:3:4 with lines notitle,\
      R*cos(u),R*sin(u),v notitle
set term qt
set xlabel ""
set ylabel ""
set zlabel ""
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
