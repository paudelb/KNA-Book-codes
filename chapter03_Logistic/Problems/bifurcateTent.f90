!===========================================================
! Bifurcation Diagram of the Logistic Map
!===========================================================
program bifurcation_diagram
 implicit none
 real(8),parameter :: rmin   = 1.00      !1.0     !1.4141D0  !1.407D0 !1.0D0
 real(8),parameter :: rmax   = 1.03      !1.1     !1.4143D0  !1.416   !2.0D0
 real(8),parameter :: xmin   = 0.4999998 !-1000.0 !0.58555   !0.58    !-1000.0
 real(8),parameter :: xmax   = 0.5000003 !1000.0  !0.58595   !0.588   ! 1000.0
 integer,parameter :: NTRANS = 2000   !Number of discarted steps
 integer,parameter :: NSTEPS = 2000    !Number of recorded  steps
 integer,parameter :: RSTEPS = 2000  !Number of values of r 
 integer           :: i              
 real(8)           :: r,dr,x0,x1
 real(8),parameter :: PI=atan2(0.0D0,-1.0D0)
! ----- Initialize:
 open(unit=33,file='bif.dat')
 dr     = (rmax-rmin)/RSTEPS !Increment in r
! ----- Calculate:
 r = rmin
 do while ( r .le. rmax)
  x0 = 0.5D0
! ---- Transient steps: skip
  do i=2,NTRANS
   if(x1 .le. 0.5D0)then
    x1 = r*x0
   else
    x1 = r*(1.0D0-x0)
   endif
   x0 = x1
  enddo
  do i=2,NSTEPS
   if(x1 .le. 0.5D0)then
    x1 = r*x0
   else
    x1 = r*(1.0D0-x0)
   endif
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
