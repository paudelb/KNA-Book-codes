!===========================================================
! Bifurcation Diagram of the Logistic Map
!===========================================================
program bifurcation_diagram
 implicit none
 real(8),parameter :: rmin   = 3.84D0
 real(8),parameter :: rmax   = 3.852D0
 real(8),parameter :: xmin   = 0.0
 real(8),parameter :: xmax   = 1.0
!real(8),parameter :: rmin   = 3.5699456666199429D0
!real(8),parameter :: rmax   = 3.56994567747000024D0
!real(8),parameter :: xmin   = 0.508527599999999969D0
!real(8),parameter :: xmax   = 0.508527863999999941D0
! real(8),parameter :: rmin   = 3.5699455573912382D0
! real(8),parameter :: rmax   = 3.5699460573912400D0
! real(8),parameter :: xmin   = 0.508526D0
! real(8),parameter :: xmax   = 0.508537D0
 integer,parameter :: NTRANS = 5000   !Number of discarted steps
 integer,parameter :: NSTEPS = 100   !Number of recorded  steps
 integer,parameter :: RSTEPS = 2000  !Number of values of r 
 integer           :: i              
 real(8)           :: r,dr,x0,x1
! ----- Initialize:
 open(unit=33,file='bif.dat')
 dr     = (rmax-rmin)/RSTEPS !Increment in r
! ----- Calculate:
 r = rmin
 do while ( r .le. rmax)
  x0 = 0.5D0
! ---- Transient steps: skip
  do i=2,NTRANS
   x1 = r * x0 * (1.0D0-x0)
   x0 = x1
  enddo
  do i=2,NSTEPS
   x1 = r * x0 * (1.0D0-x0)
   if( x1.ge.xmin .and. x1.le.xmax) write(33,*) r,x1
   x0 = x1
  enddo
  r = r + dr
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
