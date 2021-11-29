!===========================================================
!
!===========================================================
program discrete_map
 implicit none
 integer :: NSTEPS,i,in,ix,iy
 integer,parameter :: NL=200, NINIT=NL*NL
 real(8) :: r,q,x0(NL,NL),x1(NL,NL),y0(NL,NL),y1(NL,NL)
 real(8) :: dx,dy,xmin,xmax,ymin,ymax

! ----- Input:      
 print *,'# Enter NSTEPS, r, q:'
 read  *,NSTEPS,r,q
 print *,'# NSTEPS = ',NSTEPS
 print *,'# r      = ',r,' q= ',q

 xmin = 0.6D0;xmax = 0.8D0;
 ymin = 0.6D0;ymax = 0.8D0;
 dx   = (xmax-xmin)/(NL-1)
 dy   = (ymax-ymin)/(NL-1)

! original points in a square:
 do iy=1,NL
  do ix=1,NL
   x0(ix,iy) = xmin + (ix-1)*dx
   y0(ix,iy) = ymin + (iy-1)*dy
  enddo
 enddo
! ----- Calculate:
 do i=1,NSTEPS
  
  do iy=1,NL
   do ix=1,NL
    x1(ix,iy) = y0(ix,iy)+1.0D0-r*x0(ix,iy)*x0(ix,iy)
    y1(ix,iy) = q*x0(ix,iy)
    x0(ix,iy)  = x1(ix,iy); y0(ix,iy)=y1(ix,iy)
   enddo
  enddo
 enddo

 do ix=1,NL
  do iy=1,NL
   print *,x0(ix,iy),y0(ix,iy)
  enddo
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
