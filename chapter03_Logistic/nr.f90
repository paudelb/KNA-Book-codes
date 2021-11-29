!===========================================================
!Newton Raphson of function of one variable
!===========================================================
program NewtonRaphson
 implicit none
 real(8), parameter :: rho  = 15.0D0
 real(8), parameter :: eps  = 1D-6
 integer, parameter :: NMAX = 1000
 real(8) :: x0, x1, err, g, gp
 integer :: i
 print *, 'Enter x0: '
 read  *, x0
 err = 1.0D0
 print *,'iter           x                        error    '
 print *,'-------------------------------------------------'
 print *, 0,x0,err
 do i=1,NMAX
!value of function g(x):
  g   = x0*tan(x0)-sqrt(rho*rho-x0*x0)
!value of the derivative g'(x):
  gp  = x0/sqrt(rho*rho-x0*x0)+x0/(cos(x0)**2)+tan(x0)
  x1  = x0 - g/gp
  err = ABS(x1-x0)
  print *,i,x1,err
  if(err .lt. eps) exit
  x0 = x1
 enddo
end program NewtonRaphson

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
