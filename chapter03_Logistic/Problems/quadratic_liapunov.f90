!===========================================================
!Discrete Logistic Map:
!Liapunov exponent from sum_i ln|f'(x_i)|
!Calculation for r in [rmin,rmax] with RSTEPS steps
! RSTEPS: values or r studied: r=rmin+(rmax-rmin)/RSTEPS
! NTRANS: number of discarted iteration in order to discart
!         transient behaviour
! NSTEPS: number of terms in the sum
! xstart: value of initial x0 for every r
!===========================================================
program logistic_map
 implicit none
 real(8),parameter :: rmin   = 0.1D0
 real(8),parameter :: rmax   = 2.0D0
 real(8),parameter :: xstart = 0.2D0
 integer,parameter :: RSTEPS = 1000
 integer,parameter :: NSTEPS = 2000
 integer,parameter :: NTRANS = 2000
 integer :: i,ir
 real(8) :: r,x0,x1,sum,dr
 real(8),parameter :: PI=atan2(0.0D0,-1.0D0)

 open(unit=33,file='lia.dat')
 dr = (rmax-rmin)/(RSTEPS-1)
 do ir=0,RSTEPS-1
  r = rmin+ir*dr
  x0= xstart
  do i=1,NTRANS
   x1  =  1-r*x0*x0
   x0  = x1
  enddo
  sum = log(ABS( -2.0D0*r*x1 ))
! ----- Calculate:
  do i=2,NSTEPS
   x1  =  1-r*x0*x0
   sum = sum + log(ABS( -2.0D0*r*x1 ))
   x0  = x1
  enddo
  write(33,*)r,sum/NSTEPS
 enddo !do ir=0,RSTEPS-1
 close(33)
end program logistic_map


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
