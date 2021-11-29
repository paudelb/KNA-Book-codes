set term post color eps
set out "conical_pendulum_xyzt.eps"
plot   "ConicalPendulum.dat" u 1:2 with lines title "x(t)",\
       "ConicalPendulum.dat" u 1:3 with lines title "y(t)",\
       "ConicalPendulum.dat" u 1:4 with lines title "z(t)" 
set out
set out "conical_pendulum_vxyzt.eps"
plot   "ConicalPendulum.dat" u 1:5 with lines title "v_x(t)",\
       "ConicalPendulum.dat" u 1:6 with lines title "v_y(t)",\
       "ConicalPendulum.dat" u 1:7 with lines title "v_z(t)" 
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
