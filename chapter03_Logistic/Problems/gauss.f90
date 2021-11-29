!===========================================================
!
!===========================================================
program discrete_map
 implicit none
 integer :: NSTEPS,i
 real(8) :: r,q,x0,x1

! ----- Input:      
 print *,'# Enter NSTEPS, r, q,x0:'
 read  *,NSTEPS,r,q,x0
 print *,'# NSTEPS = ',NSTEPS
 print *,'# r      = ',r,' q= ',q
 print *,'# x0     = ',x0

! ----- Initialize:
 print *, 1,x0
! ----- Calculate:
 do i=2,NSTEPS
  x1 = exp(-r*x0*x0)+q
  print *,i,x1
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
