!===============================
!Sets number of equations
!===============================
subroutine finit(NEQ)
 NEQ = 8
end subroutine finit
!===============================
!Two particles of the same 
!mass on the plane interacting 
!via Coulombic force
!===============================
subroutine f(t,X,dXdt)
 implicit none
 real(8) ::        k1,k2
 common /couplings/k1,k2
 real(8) :: t,X(:),dXdt(:)
!-----------------------
 real(8) :: x11,x12,x21,x22
 real(8) :: v11,v12,v21,v22
 real(8) :: r,r3
!-----------------------
 x11 = X(1);x21 = X(5)
 x12 = X(2);x22 = X(6)
 v11 = X(3);v21 = X(7)
 v12 = X(4);v22 = X(8)
!-----------------------
 r   = sqrt((x11-x21)*(x11-x21)+(x12-x22)*(x12-x22))
 r3  = 1.0D0/r**3
 dXdt(1) = v11
 dXdt(2) = v12
 dXdt(3) = k1*(x11-x21)*r3 ! a11=dv11/dt
 dXdt(4) = k1*(x12-x22)*r3 ! a12=dv12/dt
 dXdt(5) = v21
 dXdt(6) = v22
 dXdt(7) = -dXdt(3)        ! a21=dv21/dt
 dXdt(8) = -dXdt(4)        ! a22=dv22/dt
end subroutine f
!===============================
real(8) function energy(t,X)
 implicit none
 real(8) ::        k1,k2
 common /couplings/k1,k2
 real(8) :: t,X(:)
!-----------------------
 real(8) :: x11,x12,x21,x22
 real(8) :: v11,v12,v21,v22
 real(8) :: r,r3
!-----------------------
 x11 = X(1);x21 = X(5)
 x12 = X(2);x22 = X(6)
 v11 = X(3);v21 = X(7)
 v12 = X(4);v22 = X(8)
!-----------------------
 energy = 0.5D0*(v11*v11+v12*v12+v21*v21+v22*v22)
 r      = sqrt((x11-x21)*(x11-x21)+(x12-x22)*(x12-x22))
 energy = energy + k1/r
end function energy
!( echo -0.5 0 ; echo 40000 0 10 -1 1 0.3 0 1 -1 -0.3 0 ) | ./a.out
!( echo  0.5 0 ; echo 40000 0 10 -1 1 0.3 0 1 -1 -0.3 0 ) | ./a.out
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
