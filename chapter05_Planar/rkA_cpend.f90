!===============================
!Sets number of equations
!===============================
subroutine finit(NEQ)
 NEQ = 4
end subroutine finit
!===============================
!Two equal mass pendulums coupled
!with a spring
!===============================
subroutine f(t,X,dXdt)
 implicit none
 real(8) ::        k1,k2
 common /couplings/k1,k2
 real(8) :: t,X(:),dXdt(:)
!-----------------------
 real(8) :: th1,th2,om1,om2
 real(8) :: cth1,sth1,cth2,sth2
 real(8) :: r,Dl
!-----------------------
 th1  = X(1);     th2  = X(3)
 om1  = X(2);     om2  = X(4)
!-----------------------
 cth1 = cos(th1); sth1 = sin(th1)
 cth2 = cos(th2); sth2 = sin(th2)
!-----------------------
 r    = sqrt((1+sth2-sth1)**2+(cth1-cth2)**2)
 Dl   = r - 1.0D0
 dXdt(1) = om1
 dXdt(2) = -k1*sth1+k2*Dl/r*( (1.0D0+sth2-sth1)*cth1+(cth1-cth2)*sth1 )
 dXdt(3) = om2
 dXdt(4) = -k1*sth2-k2*Dl/r*( (1.0D0+sth2-sth1)*cth2+(cth1-cth2)*sth2 )
end subroutine f
!===============================
!this is E/(m*l*l)
real(8) function energy(t,X)
 implicit none
 real(8) ::        k1,k2
 common /couplings/k1,k2
 real(8) :: t,X(:)
!-----------------------
 real(8) :: th1,th2,om1,om2
 real(8) :: cth1,sth1,cth2,sth2
 real(8) :: r,Dl
!-----------------------
 th1  = X(1);      th2 = X(3)
 om1  = X(2);      om2 = X(4)
!-----------------------
 cth1 = cos(th1); sth1 = sin(th1)
 cth2 = cos(th2); sth2 = sin(th2)
 r    = sqrt((1+sth2-sth1)**2+(cth1-cth2)**2)
 Dl   = r - 1.0D0
!-----------------------
 energy = 0.5D0*(om1*om1+om2*om2)
 energy = energy -k1*(cth1+cth2) + 0.5D0*k2*Dl*Dl 
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
