!===========================================================
!Discrete Logistic Map:
!Liapunov exponent from sum_i ln|f'(x_i)|
! NTRANS: number of discarted iteration in order to discart
!         transient behaviour
! NSTEPS: number of terms in the sum
!===========================================================
program logistic_map
 implicit none
 integer :: NTRANS,NSTEPS,i
 real(8) :: r,x0,x1,sum

! ----- Input:      
 print *,'# Enter NTRANS,NSTEPS, r, x0:'
 read  *,NTRANS,NSTEPS,r,x0
 print *,'# NTRANS  = ',NTRANS
 print *,'# NSTEPS  = ',NSTEPS
 print *,'# r       = ',r
 print *,'# x0      = ',x0

 do i=1,NTRANS
  x1  = r * x0  * (1.0D0-x0 )
  x0  = x1
 enddo
 sum = log(ABS(r*(1.0D0-2.0D0*x0)))
! ----- Initialize:
 open(unit=33,file='lia.dat')
 write(33,*) 1,x0,sum
! ----- Calculate:
 do i=2,NSTEPS
  x1  = r * x0  * (1.0D0-x0 )
  sum = sum + log(ABS(r*(1.0D0-2.0D0*x1)))
  write(33,*)i,x1,sum/i
  x0  = x1
 enddo
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
