!========================================================
!  Particle in constant Magnetic and electric field
!  q B/m = k1 z   q E/m = k2 x + k3 y + k4 z
!========================================================
subroutine F(T,Y,YP)
 include 'sr.inc'
 real(8) :: t
 real(8) :: Y(*),YP(*)
 real(8) :: x1,x2,x3,v1,v2,v3,p1,p2,p3
 x1 = Y(1);p1 = Y(4)
 x2 = Y(2);p2 = Y(5)
 x3 = Y(3);p3 = Y(6)
 call velocity(p1,p2,p3,v1,v2,v3) 
!now we can use all x1,x2,x3,p1,p2,p3,v1,v2,v3
 YP(1) = v1
 YP(2) = v2
 YP(3) = v3
!Acceleration: 
 YP(4) = k2 + k1 * v2
 YP(5) = k3 - k1 * v1
 YP(6) = k4
end subroutine F
!========================================================
!Energy per unit rest mass
!========================================================
real(8) function energy(T,Y)
 include 'sr.inc'
 real(8) :: t,e
 real(8) :: Y(*)
 real(8) :: x1,x2,x3,v1,v2,v3,p1,p2,p3,psq
 x1 = Y(1);p1 = Y(4)
 x2 = Y(2);p2 = Y(5)
 x3 = Y(3);p3 = Y(6)
 psq= p1*p1+p2*p2+p3*p3
!Kinetic Energy/m_0
 e = sqrt(1.0D0+psq)-1.0D0
!Potential Energy/m_0
 e = e - k2*x1 - k3*x2 - k4*x3
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
