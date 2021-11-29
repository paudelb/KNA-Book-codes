# Usage: In order to animate data in file.dat do the following:
# gnuplot> L     = 10 ; R = 10
# gnuplot> t0    = 0
# gnuplot> tf    = 10
# gnuplot> dt    = 0.01
# gnuplot> load "Cylinder3D_animate.gnu"
file="Cylinder3D.dat"
set macros
set size square
# -----------------------------
t0 = t0 + dt 
command = "awk -v t=".sprintf("%f",t0)." '$1<t{print $2}' ".file."|tail -n 1"
x0 = `@command`
command = "awk -v t=".sprintf("%f",t0)." '$1<t{print $3}' ".file."|tail -n 1"
y0 = `@command`
command = "awk -v t=".sprintf("%f",t0)." '$1<t{print $4}' ".file."|tail -n 1"
z0 = `@command`
set  arrow 1 from 0,0,0 to x0,y0,z0
# show arrow 1
# set title "t= ".sprintf("%f (x,y) = %s",t0,axy)
set title "t= ".sprintf("%f (x,y,z)= (%f,%f,%f)",t0,x0,y0,z0)
set urange [0:2.0*pi]
set vrange [0:L]
set xrange [-R:R];set yrange [-R:R]; set zrange [0:L]
set parametric
set xlabel "x"
set ylabel "y"
set zlabel "z"
splot file \
 using 2:($1<= t0 ? $3: 1/0):($1<= t0 ? $4: 1/0) with lines notitle,\
      R*cos(u),R*sin(u),v notitle
# pause sleep
if(t0<tf) reread
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
