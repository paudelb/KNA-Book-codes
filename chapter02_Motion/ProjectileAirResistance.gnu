# set motion parameters here:
v0x = 10*cos(pi/4) ; v0y = 10*sin(pi/4) ;g = 9.81 ; k = 5 
set term post color eps    
set out "projectileAirResistance_xy.eps"
plot [:][:v0x/k+0.1]  "ProjectileAirResistance.dat" \
         using 1:2 with lines title "x(t)",v0x/k ,  \
                      "ProjectileAirResistance.dat" \
         using 1:3 with lines title "y(t)",-(g/k)*x+(g/k**2)+v0y/k
set out
set out "projectileAirResistance_vxy.eps"
plot [:][-g/k-0.6:]   "ProjectileAirResistance.dat" \
         using 1:4 with lines title "v_x(t)",0,     \
                      "ProjectileAirResistance.dat" \
         using 1:5 with lines title "v_y(t)",-g/k   
set out
set out "projectileAirResistance_traj.eps"        
plot                  "ProjectileAirResistance.dat" \
         using 2:3 with lines title "With air resistance k=5.0" ,\
                      "Projectile.dat"              \
         using 2:3 with lines title "No air resistance k=0.0" 
set out
set term qt
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
