!===========================================================
!Discrete Logistic Map:
!Two trajectories with close initial conditions.
!===========================================================
program logistic_map
 implicit none
 integer :: NSTEPS,i
 real(8) :: r,x0,x1,x0t,x1t,epsilon

! ----- Input:      
 print *,'# Enter NSTEPS, r, x0, epsilon:'
 read  *,NSTEPS,r,x0,epsilon
 print *,'# NSTEPS  = ',NSTEPS
 print *,'# r       = ',r
 print *,'# x0      = ',x0
 print *,'# epsilon = ',epsilon

 x0t = x0+epsilon
! ----- Initialize:
 open(unit=33,file='lia.dat')
 write(33,*) 1,x0,x0t,ABS(x0t-x0)/epsilon
! ----- Calculate:
 do i=2,NSTEPS
  x1  = r * x0  * (1.0D0-x0 )
  x1t = r * x0t * (1.0D0-x0t)
  write(33,*)i,x1,x1t,ABS(x1t-x1)/epsilon
  x0  = x1; x0t = x1t
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
