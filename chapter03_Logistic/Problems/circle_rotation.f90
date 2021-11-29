!===========================================================
! does not work...
!===========================================================
program discrete_map
 implicit none
 real(8),parameter  :: PI=atan2(0.0D0,-1.0D0)
!-----------------------------------------------------------
 real(8),parameter  :: rmin = 0.0D0
 real(8),parameter  :: rmax = 1.0D0
 real(8)            :: q      = PI/15.0!0.1591549431+0.05!1.0D0/(2.0D0*PI)-0.05
 real(8)            :: r
 integer,parameter  :: NTRANS = 10000
 integer,parameter  :: NSTEPS = 10000
 integer,parameter  :: RSTEPS = 200
 integer,parameter  :: NAV    = 1000
 real(8),parameter  :: xstart = 0.21D0

 integer :: i
 real(8) :: x0,x1,sum,sum1,dr,avsum

 dr   = (rmax-rmin)/(RSTEPS-1)
! ----- Input:      
 r    = rmin
 do while( r .le. rmax)
  x0  = xstart
  do i=1,NTRANS
   x1 = x0+r-q*sin(2.0D0*PI*x0)
   if(x1 .gt. 1.0D0) x1 = x1-INT(x1)        !x modulo 1
   if(x1 .lt. 0.0D0) x1 = x1-INT(x1)+1.0D0
   x0 = x1
  enddo
  sum   = x0
  do i=2,NSTEPS-NAV
   x1 = x0+r-q*sin(2.0D0*PI*x0)
   if(x1 .gt. 1.0D0) x1 = x1-INT(x1)        !x modulo 1
   if(x1 .lt. 0.0D0) x1 = x1-INT(x1)+1.0D0
   sum  = sum + x1
   x0   = x1
  enddo
  avsum = 0.0D0
  do i=NSTEPS-NAV+1,NSTEPS
   x1 = x0+r-q*sin(2.0D0*PI*x0)
   if(x1 .gt. 1.0D0) x1 = x1-INT(x1)        !x modulo 1
   if(x1 .lt. 0.0D0) x1 = x1-INT(x1)+1.0D0
   sum   = sum + x1
   avsum = avsum +sum/i
   x0    = x1
  enddo
  print *,r,sum/NSTEPS,avsum/NAV
  r = r+dr
 enddo !do while( r .le. rmax)

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
