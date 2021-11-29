!===========================================================
! Bifurcation Diagram of the Logistic Map
!===========================================================
program bifurcation_diagram
 implicit none
 real(8),parameter :: rmin   = 3.8535D0
 real(8),parameter :: rmax   = 3.8544D0
 real(8),parameter :: XMIN   = 0.496D0
 real(8),parameter :: XMAX   = 0.506D0
 integer,parameter :: NTRANS = 500   !Number of discarted steps
 integer,parameter :: NSTEPS = 100   !Number of recorded  steps
 integer,parameter :: RSTEPS = 2000  !Number of values of r 
 integer           :: i,iprint              
 real(8)           :: r,dr,x0,x1
! ----- Initialize:
 open(unit=33,file='bif.dat')
 dr     = (rmax-rmin)/RSTEPS !Increment in r
! ----- Calculate:
 r = rmin
 do while ( r .le. rmax)
  x0 = 0.5D0
! ---- Transient steps: skip
  do i=1,NTRANS
   x1 = r * x0 * (1.0D0-x0)
   x0 = x1
  enddo
  iprint = 0
  do i=1,20000
   x1 = r * x0 * (1.0D0-x0)
   if( x1 > XMIN .and. x1 < XMAX)then
    write(33,*) r,x1
    iprint = iprint + 1
   end if
   x0 = x1
   if(iprint >= NSTEPS) exit
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
