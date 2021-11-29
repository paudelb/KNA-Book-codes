!========================================================
!  Particle in Magnetic dipole field:
!  q B_1/m = k1 (3 x1 x3)/r^5 
!  q B_2/m = k1 (3 x2 x3)/r^5 
!  q B_3/m = k1[(3 x3 x3)/r^5-1/r^3]
!======================================================== 
subroutine F(T,Y,YP)
 include 'sr.inc'
 real(8) :: t
 real(8) :: Y(*),YP(*)
 real(8) :: x1,x2,x3,v1,v2,v3,p1,p2,p3
 real(8) :: B1,B2,B3
 real(8) :: r
 x1 = Y(1);p1 = Y(4)
 x2 = Y(2);p2 = Y(5)
 x3 = Y(3);p3 = Y(6)
 call velocity(p1,p2,p3,v1,v2,v3) 
!now we can use all x1,x2,x3,p1,p2,p3,v1,v2,v3
 YP(1)  = v1
 YP(2)  = v2
 YP(3)  = v3
!Acceleration: 
 r      = sqrt(x1*x1+x2*x2+x3*x3)
 if( r.gt.0.0D0)then
  B1    = k1*( 3.0D0*x1*x3)/r**5
  B2    = k1*( 3.0D0*x2*x3)/r**5
  B3    = k1*((3.0D0*x3*x3)/r**5-1/r**3)
  YP(4) = v2*B3-v3*B2
  YP(5) = v3*B1-v1*B3
  YP(6) = v1*B2-v2*B1
 else
  YP(4) = 0.0D0
  YP(5) = 0.0D0
  YP(6) = 0.0D0
 endif      
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
