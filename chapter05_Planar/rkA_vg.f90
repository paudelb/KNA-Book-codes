!===============================
!Sets number of equations
!===============================
subroutine finit(NEQ)
 NEQ = 4
end subroutine finit
!===============================
!Motion on the plane
!a1 = -k2 vx    a2 = -k2 vy - k1
!===============================
subroutine f(t,X,dXdt)
 implicit none
 real(8) ::        k1,k2
 common /couplings/k1,k2
 real(8) :: t,X(:),dXdt(:)
!-----------------------
 real(8) :: x1,x2
 real(8) :: v1,v2
!-----------------------
 x1 = X(1)
 x2 = X(2)
 v1 = X(3)
 v2 = X(4)
!-----------------------
 dXdt(1) =  v1
 dXdt(2) =  v2
 dXdt(3) = -k2*v1    ! a1=dv1/dt
 dXdt(4) = -k2*v2-k1 ! a2=dv2/dt
end subroutine f
!===============================
real(8) function energy(t,X)
 implicit none
 real(8) ::        k1,k2
 common /couplings/k1,k2
 real(8) :: t,X(:)
!-----------------------
 real(8) :: x1,x2
 real(8) :: v1,v2
!-----------------------
 x1 = X(1)
 x2 = X(2)
 v1 = X(3)
 v2 = X(4)
!-----------------------
 energy = 0.5D0*(v1*v1+v2*v2)
 energy = energy + k1*x2
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
