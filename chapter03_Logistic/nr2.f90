!===========================================================
!Newton Raphson of two functions of two variables
!===========================================================
program NewtonRaphson2
 implicit none
 real(8), parameter :: eps  = 1D-6
 integer, parameter :: NMAX = 1000
 real(8) :: A(2,2),b(2),dx(2)
 real(8) :: x,y, err
 integer :: i
 print *, 'Enter x0,y0: '
 read  *, x,y
 err = 1.0D0
 print *,'iter           x          y             error    '
 print *,'-------------------------------------------------'
 print *, 0,x,y,err
 do i=1,NMAX
  b(1)   = -(2.0D0*x*x-3.0D0*x*y+y-2.0D0) ! -g1(x,y)
  b(2)   = -(3.0D0*x + x*y + y - 1.0D0)   ! -g2(x,y)
! dg1/dx                    dg1/dy
  A(1,1) = 4.0D0*x-3.0D0*y; A(1,2) = 1.0D0-3.0D0*x
! dg2/dx                    dg2/dy
  A(2,1) = 3.0D0+y        ; A(2,2) = 1.0D0+x 
  call solve2x2(A,B,dx)
  x = x + dx(1)
  y = y + dx(2)
  err = 0.5D0*SQRT(dx(1)**2+dx(2)**2)
  print *,i,x,y,err
  if(err .lt. eps) exit
 enddo
end program NewtonRaphson2
!===========================================================
subroutine solve2x2(A,b,dx)
 implicit none
 real(8) :: A(2,2),b(2),dx(2)
 real(8) :: num1,num2,det
 num1 = A(2,2)*b(1)-A(1,2)*b(2)
 num2 = A(1,1)*b(2)-A(2,1)*b(1)
 det  = A(1,1)*A(2,2)-A(1,2)*A(2,1)
 if(det .eq. 0.0D0) stop 'solve2x2: det=0'
 dx(1)= num1/det
 dx(2)= num2/det
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
