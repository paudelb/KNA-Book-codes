!===========================================================
!        bifurcationPoints.f
! Calculate bifurcation points of the discrete logistic equation
! at period k by solving the condition 
! g1(x,r) = x - F(k,x,r)   = 0
! g2(x,r) = dF(k,x,r)/dx+1 = 0
! determining when the Floquet multiplier bacomes 1
! F(k,x,r) iterates F(x,r) = r*x*(x-1) k times
! The equations are solved by using a Newton-Raphson method
!===========================================================
program bifurcationPoints
 implicit none
 real(8),parameter :: tol=1.0D-12
 integer :: k,iter
 real(8) :: r0,x0
 real(8) :: A(2,2),B(2),dX(2)
 real(8) :: error
 real(8) :: F,dFdx,dFdr,d2Fdx2,d2Fdrdx
 real(8) :: epsilon
 common /eeps/epsilon
! ---- Input:
 print *,'# Enter k,r0,x0,epsilon:'
 read  *,k,r0,x0,epsilon
 print *,'# Period k= ',k
 print *,'# r0= ',r0,' x0= ',x0
 print *,'# epsilon= ',epsilon
! ---- Initialize
 error   = 1.0D0           !initial large value of error>tol
 iter    = 0
 do while(error .gt. tol)
! ---- Calculate jacobian matrix
  A(1,1) = 1.0D0-dFdx(k,x0,r0)
  A(1,2) = -dFdr     (k,x0,r0)
  A(2,1) = d2Fdx2    (k,x0,r0)
  A(2,2) = d2Fdrdx   (k,x0,r0)
  B(1)   = -x0 +    F(k,x0,r0)
  B(2)   = -dFdx     (k,x0,r0)-1.0D0
! ---- Solve a 2x2 linear system:
  call solve2x2(A,B,dX)
  x0     = x0 + dX(1)
  r0     = r0 + dX(2)
  error  = 0.5D0*sqrt(dX(1)**2+dX(2)**2)
  iter   = iter+1
  print*,iter,'x0= ',x0,' r0= ',r0,' err=',error
 enddo !do while(error .gt. tol)
end program bifurcationPoints
!===========================================================
!Function F(k,x,r) and its derivatives
real(8) function F(k,x,r)
 implicit none
 real(8) :: x,r,x0
 integer k,i

 x0  = x
 do i=1,k
  x0 = r*x0*(1.0D0-x0)
 enddo
 F   = x0
 
end function F
! ----------------------------------
real(8) function dFdx(k,x,r)
 implicit none
 real(8) :: x,r,eps
 real(8) :: F
 integer k
 real(8) :: epsilon
 common /eeps/epsilon
 eps     = epsilon*ABS(x)
 dFdx    = (F(k,x+eps,r)-F(k,x-eps,r))/(2.0D0*eps)
end function dFdx
! ----------------------------------
real(8) function dFdr(k,x,r)
 implicit none
 real(8) :: x,r,eps
 real(8) :: F
 integer k
 real(8) :: epsilon
 common /eeps/epsilon

 eps     = epsilon*ABS(r)
 dFdr    = (F(k,x,r+eps)-F(k,x,r-eps))/(2.0D0*eps)
end function dFdr
! ----------------------------------
real(8) function d2Fdx2(k,x,r)
 implicit none
 real(8) :: x,r,eps
 real(8) :: F
 integer k
 real(8) :: epsilon
 common /eeps/epsilon

 eps     = epsilon*ABS(x)
 d2Fdx2  = (F(k,x+eps,r)-2.0D0*F(k,x,r)+F(k,x-eps,r))/(eps*eps)
end function d2Fdx2
! ----------------------------------
real(8) function d2Fdrdx(k,x,r)
 implicit none
 real(8) :: x,r,epsx,epsr
 real(8) :: F
 integer k
 real(8) :: epsilon
 common /eeps/epsilon

 epsx    = epsilon*ABS(x)
 epsr    = epsilon*ABS(r)
 d2Fdrdx = (F(k,x+epsx,r+epsr)-F(k,x+epsx,r-epsr) &
      -F(k,x-epsx,r+epsr)+F(k,x-epsx,r-epsr))     &
          /(4.0D0*epsx*epsr)
end function d2Fdrdx
!===========================================================
subroutine solve2x2(A,b,dx)
 implicit none
 real(8) :: A(2,2),b(2),dx(2)
 real(8) :: num1,num2,det
 num1 = A(2,2)*b(1)  - A(1,2)*b(2)
 num2 = A(1,1)*b(2)  - A(2,1)*b(1)
 det  = A(1,1)*A(2,2)- A(1,2)*A(2,1)
 if(det .eq. 0.0D0) stop 'solve2x2: det = 0'
 dx(1) = num1/det
 dx(2) = num2/det
end subroutine solve2x2
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
