!===========================================================
!
!===========================================================
program discrete_map
 implicit none
 real(8),parameter :: a= 0.9000D0
 real(8),parameter :: b=-0.6013D0
 real(8),parameter :: c= 2.0000D0
 real(8),parameter :: d= 0.5000D0
 integer :: NSTEPS,i,in,ix,iy
 integer,parameter :: NL=500, NINIT=NL*NL
 real(8) :: r,q,x0,x1,y0,y1
 real(8) :: dx,dy,xmin,xmax,ymin,ymax

! ----- Input:      
 print *,'# Enter NSTEPS:'
 read  *,NSTEPS
 print *,'# NSTEPS = ',NSTEPS

 x0   = -0.72; y0    = -0.64
! ----- Calculate:
 do i=1,NSTEPS
  
    x1 = x0*x0-y0*y0+a*x0+b*y0
    y1 = 2.0D0*x0*y0+c*x0+d*y0
    x0 = x1; y0=y1
    print *,x0,y0
 enddo

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
