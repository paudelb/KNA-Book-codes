!===========================================================
! Bifurcation Diagram
!===========================================================
program bifurcation_diagram
 implicit none
 real(8),parameter :: qmin   =  -1.D0
 real(8),parameter :: qmax   =   1.D0
 real(8)           :: q
 real(8),parameter :: rmin   =  -1.D0
 real(8),parameter :: rmax   =   1.D0
 real(8)           :: r      =  7.5D0  
 real(8),parameter :: xmin   = -1000
 real(8),parameter :: xmax   =  1000
 integer,parameter :: NTRANS = 2000   !Number of discarted steps
 integer,parameter :: NSTEPS = 100    !Number of recorded  steps
 integer,parameter :: RSTEPS = 2000  !Number of values of r 
 integer           :: i              
 real(8)           :: dr,x0,x1,dq
 real(8),parameter :: PI=atan2(0.0D0,-1.0D0)
! ----- Initialize:
 open(unit=33,file='bif.dat')
 x0 = 0!1.0D0/sqrt(2.0D0)!0.5D0
! dr     = (rmax-rmin)/RSTEPS !Increment in r
 dq     = (qmax-qmin)/RSTEPS !Increment in q
! ----- Calculate:
! r = rmin
! do while ( r .le. rmax)
 q = qmin
 do while ( q .le. qmax)
! q = qmax
! do while ( q .ge. qmin)
!  x0 = 1.0D0/sqrt(2.0D0)!0.5D0
! ---- Transient steps: skip
  do i=2,NTRANS
   x1 = exp(-r*x0*x0)+q
   x0 = x1
  enddo
  do i=2,NSTEPS
   x1 = exp(-r*x0*x0)+q
!   if( x1.ge.xmin .and. x1.le.xmax) write(33,*) r,x1
   if( x1.ge.xmin .and. x1.le.xmax) write(33,*) q,x1
   x0 = x1
  enddo
!  r = r + dr
  q = q + dq
 enddo ! do while
 close(33)
end program bifurcation_diagram
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
