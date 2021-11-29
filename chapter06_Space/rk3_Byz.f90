!--------------------------------------
!Particle in Magnetic field:
!q B_z/m = (k1 + k2 y)  q B_y/m=  k3 z 
subroutine F(T,Y,YP)
 include 'rk3.inc'
 real(8) :: t
 real(8) :: Y(*),YP(*)
 real(8) :: x1,x2,x3,v1,v2,v3,x3p
 x1 = Y(1);v1 = Y(4)
 x2 = Y(2);v2 = Y(5)
 x3 = Y(3);v3 = Y(6)
!Velocities:   dx_i/dt = v_i
 YP(1) = v1
 YP(2) = v2
 YP(3) = v3
!Acceleration: dv_i/dt = a_i
 YP(4) =  v2*(k1+k2*x2)-v3*k3*x3
 YP(5) = -v1*(k1+k2*x2)
 YP(6) =  v1*k3*x3
end subroutine F
!---------------------------------
real(8) function energy(T,Y)
 include 'rk3.inc'
 real(8) :: t,e
 real(8) :: Y(*)
 real(8) :: x1,x2,x3,v1,v2,v3
 x1 = Y(1);v1 = Y(4)
 x2 = Y(2);v2 = Y(5)
 x3 = Y(3);v3 = Y(6)
!Kinetic Energy
 e = 0.5*(v1*v1+v2*v2+v3*v3)
 energy = e
end function energy
!  ---------------------------------------------------------------------
!  Copyright by Konstantinos N. Anagnostopoulos (2004-2014)
!  Physics Dept., National Technical University,
!  konstant@mail.ntua.gr, www.physics.ntua.gr/~konstant
!  
!  This program is free software: you can redistribute it and/or modify
!  it under the terms of the GNU General Public License as published by
!  the Free Software Foundation, version 3 of the License.
!  
!  This program is distributed in the hope that it will be useful, but
!  WITHOUT ANY WARRANTY; without even the implied warranty of
!  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
!  General Public License for more details.
!  
!  You should have received a copy of the GNU General Public Liense along
!  with this program.  If not, see <http://www.gnu.org/licenses/>.
!  -----------------------------------------------------------------------
