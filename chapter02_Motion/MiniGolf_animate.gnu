# Usage: In order to animate data in file.dat do the following:
# gnuplot> file  = "file.dat"
# gnuplot> Lx    = 10 ; Ly = 10
# gnuplot> xc    = 8  ; yc = 2.5 ; R = 0.5
# gnuplot> t0=0;dt=0.1
# gnuplot> load "MiniGolf_animate.gnu"

set macros
set size ratio -1
# -----------------------------
t0 = t0 + dt 
command = "awk -v t=".sprintf("%f",t0)." '$1<t{print $2}' ".file."|tail -n 1"
x0 = `@command`
command = "awk -v t=".sprintf("%f",t0)." '$1<t{print $3}' ".file."|tail -n 1"
y0 = `@command`
holeplot =  "< echo ".sprintf("%f",xc)." ".sprintf("%f",yc)
set arrow 1 from 0,Ly/2.0 to x0,y0
set arrow 5 from 0,0  to Lx,0  nohead linewidth 4
set arrow 3 from 0,Ly to Lx,Ly nohead linewidth 4
set arrow 4 from Lx,0 to Lx,Ly nohead linewidth 4
set title "t= ".sprintf("%f (x,y)= (%f,%f)",t0,x0,y0)
plot  [-0.1*Lx:1.1*Lx][-0.1*Ly:1.1*Ly] file \
 using 2:($1<= t0 ? $3: 1/0) with lines notitle,\
 yc+sqrt(R**2-(x-xc)**2) notit,yc-sqrt(R**2-(x-xc)**2) notit
# pause sleep
command = 'tail -n 1 '.file."|awk '{print $1}'"
tf      = `@command`
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
