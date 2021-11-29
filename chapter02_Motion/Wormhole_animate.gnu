# Usage: In order to animate data in file.dat do the following:
# gnuplot> file  = "Wormhole.dat"
# gnuplot> d = 5; R = 1; L = 20;
# gnuplot> t0=0;dt=0.1
# gnuplot> load "Wormhole_animate.gnu"

# set size ratio -1
# d = 5; R = 1; L = 20;
# plot [-0.51*L:0.51*L][-0.51*L:0.51*L] "Wormhole.dat" u 2:3 w l not,c1p(x) not,c1m(x) not,c2p(x) not, c2m(x) not

# set size ratio -1
# d = 5; R = 1; L = 20;
# set parametric
# set pointsize 0.2
# plot [-0.5*L:0.5*L] d/2.+R*cos(t),R*sin(t) not,-d/2.+R*cos(t),R*sin(t) not,0,t not,t,0 not,"./Wormhole.dat" u 2:3 w points not


set macros
set size ratio -1
set pointsize 0.05
set parametric
# -----------------------------
t0 = t0 + dt 
command = "awk -v t=".sprintf("%f",t0)." '$1<t{print $2}' ".file."|tail -n 1"
x0 = `@command`
command = "awk -v t=".sprintf("%f",t0)." '$1<t{print $3}' ".file."|tail -n 1"
y0 = `@command`
set arrow 1 from 0,0 to x0,y0
set title "t= ".sprintf("%f (x,y)= (%f,%f)",t0,x0,y0)
plot   [-0.5*L:0.5*L] \
       d/2.+R*cos(t),R*sin(t) not,-d/2.+R*cos(t),R*sin(t) not,\
       0,t not,t,0 not, \
       file using 2:($1<= t0 ? $3: 1/0) with points notitle
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
