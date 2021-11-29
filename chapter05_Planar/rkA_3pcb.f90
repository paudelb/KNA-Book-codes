!===============================
!Sets number of equations
!===============================
subroutine finit(NEQ)
 NEQ = 12
end subroutine finit
!===============================
!Three particles of the same 
!mass on the plane interacting 
!via Coulombic force
!===============================
subroutine f(t,X,dXdt)
 implicit none
 real(8) ::        k1,k2
 common /couplings/k1,k2
 real(8) :: t,X(:),dXdt(:)
!-----------------------
 real(8) :: x11,x12,x21,x22,x31,x32
 real(8) :: v11,v12,v21,v22,v31,v32
 real(8) :: r12,r13,r23
!-----------------------
 x11 = X(1);x21 = X(5);x31 = X(9)
 x12 = X(2);x22 = X(6);x32 = X(10)
 v11 = X(3);v21 = X(7);v31 = X(11)
 v12 = X(4);v22 = X(8);v32 = X(12)
!-----------------------
 r12 = ((x11-x21)*(x11-x21)+(x12-x22)*(x12-x22))**(-3.0D0/2.0D0)
 r13 = ((x11-x31)*(x11-x31)+(x12-x32)*(x12-x32))**(-3.0D0/2.0D0)
 r23 = ((x21-x31)*(x21-x31)+(x22-x32)*(x22-x32))**(-3.0D0/2.0D0)
!--------------
 dXdt(1)  = v11
 dXdt(2)  = v12
 dXdt(3)  = k1*(x11-x21)*r12+k1*(x11-x31)*r13 ! a11=dv11/dt
 dXdt(4)  = k1*(x12-x22)*r12+k1*(x12-x32)*r13 ! a12=dv12/dt
!--------------
 dXdt(5)  = v21
 dXdt(6)  = v22
 dXdt(7)  = k1*(x21-x11)*r12+k1*(x21-x31)*r23 ! a21=dv21/dt
 dXdt(8)  = k1*(x22-x12)*r12+k1*(x22-x32)*r23 ! a22=dv22/dt
!--------------
 dXdt(9)  = v31
 dXdt(10) = v32
 dXdt(11) = k1*(x31-x11)*r13+k1*(x31-x21)*r23 ! a31=dv31/dt
 dXdt(12) = k1*(x32-x12)*r13+k1*(x32-x22)*r23 ! a32=dv32/dt
end subroutine f
!===============================
real(8) function energy(t,X)
 implicit none
 real(8) ::        k1,k2
 common /couplings/k1,k2
 real(8) :: t,X(:)
!-----------------------
 real(8) :: x11,x12,x21,x22,x31,x32
 real(8) :: v11,v12,v21,v22,v31,v32
 real(8) :: r12,r13,r23
!-----------------------
 x11 = X(1);x21 = X(5);x31 = X(9)
 x12 = X(2);x22 = X(6);x32 = X(10)
 v11 = X(3);v21 = X(7);v31 = X(11)
 v12 = X(4);v22 = X(8);v32 = X(12)
!-----------------------
 r12 = ((x11-x21)*(x11-x21)+(x12-x22)*(x12-x22))**(-0.5D0)
 r13 = ((x11-x31)*(x11-x31)+(x12-x32)*(x12-x32))**(-0.5D0)
 r23 = ((x21-x31)*(x21-x31)+(x22-x32)*(x22-x32))**(-0.5D0)
!-----------------------
 energy = 0.5D0*(v11*v11+v12*v12+v21*v21+v22*v22+v31*v31+v32*v32)
 energy = energy + k1*(r12+r13+r23)
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
