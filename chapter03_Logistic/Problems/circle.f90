!===========================================================
!
!===========================================================
program discrete_map
 implicit none
 integer :: NSTEPS,i,NTRANS
 real(8) :: r,q,x0,x1,sum,xstart
 real(8),parameter :: PI=atan2(0.0D0,-1.0D0)

! ----- Input:      
 print *,'# Enter NTRANS,NSTEPS, r, q,x0:'
 read  *,NTRANS,NSTEPS,r,q,x0
 print *,'# NSTEPS = ',NSTEPS,' NTRANS= ',NTRANS
 print *,'# r      = ',r,' q= ',q
 print *,'# x0     = ',x0

 do i=1,NTRANS
  x1 = x0+r-q*sin(2.0D0*PI*x0)
  if(x1 .gt. 1.0D0) x1 = x1-INT(x1)        !x modulo 1
  if(x1 .lt. 0.0D0) x1 = x1-INT(x1)+1.0D0
  x0 = x1
 enddo
! ----- Initialize:
 xstart=x0
 sum=0 !x0
 print *, 1,x0,sum
! ----- Calculate:
 do i=2,NSTEPS
  x1 = x0+r-q*sin(2.0D0*PI*x0)
  if(x1 .gt. 1.0D0) x1 = x1-INT(x1)        !x modulo 1
  if(x1 .lt. 0.0D0) x1 = x1-INT(x1)+1.0D0
  sum = sum + (x1-xstart)
  print *,i,x1,sum/i
  x0 = x1
 enddo

 close(33)
end program discrete_map


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
