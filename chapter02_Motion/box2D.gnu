# Usage: file="box2D_1.dat";Lx=10;Ly=10;load "box2D_1.gnu"
set macros
epsxfile = file."_xyt.eps"
epsvfile = file."_vt.eps"
epstfile = file."_xy.eps"
#  x(t),y(t)
set term qt 1
plot file using 1:2 with lines title "x(t)",\
     file using 1:3 with lines title "y(t)"
set term postscript color eps enhanced 24
set output epsxfile
replot
set output
#  vx(t),vy(t)
set term qt 2
plot file using 1:4 with lines title "v_x(t)",\
     file using 1:5 with lines title "v_y(t)"
set term postscript color eps enhanced 24
set output epsvfile
replot
set output
# --------------------------------------------------------
#   TRAJECTORY:
# --------------------------------------------------------
set term qt 3
set arrow 1 from 0,0  to Lx,0  nohead linewidth 4
set arrow 2 from 0,0  to 0 ,Ly nohead linewidth 4
set arrow 3 from 0,Ly to Lx,Ly nohead linewidth 4
set arrow 4 from Lx,0 to Lx,Ly nohead linewidth 4
set size ratio -1
set xlabel "x"
set ylabel "y"
plot [-0.1*Lx:1.1*Lx][-0.1*Ly:1.1*Ly]\
 file using 2:3 with lines notitle
set term postscript color eps enhanced 24
set output epstfile
replot
set output
unset arrow 1
unset arrow 2
unset arrow 3
unset arrow 4
set size noratio
set term qt
set xlabel ""
set ylabel ""
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
