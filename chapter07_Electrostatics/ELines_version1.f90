!****************************************************
program Electric_Fields
!****************************************************
 implicit none
 integer,parameter :: P=20     !max number of charges
 real,dimension(P) :: X,Y,Q
 integer           :: N
 integer           :: i,j,draw
 real              :: x0,y0
!-------------  SET CHARGE DISTRIBUTION ----
 print *, '# Enter number of charges:'
 read  *, N
 print *, '# N= ',N
 do i=1,N
  print *,'# Charge: ',i
  print *,'# Position and charge: (X,Y,Q):'
  read  *,  X(i),Y(i),Q(i)
  print *,'# (X,Y)= ', X(i),Y(i), ' Q= ',Q(i)
 enddo
!-------------  DRAWING LINES  -------------
 print *,'# How many lines to draw? '
 read  *, draw
 do i=1,draw
  print *,'# Initial point (x0,y0): '
  read  *, x0,y0
  call  eline(x0,y0,X,Y,Q,N)
 enddo
end program Electric_Fields
!****************************************************
subroutine eline(xin,yin,X,Y,Q,N)
!****************************************************
 implicit  none
 integer          :: N
 real,dimension(N):: X,Y,Q
 real             :: xin,yin,x0,y0
 real,parameter   :: step=0.01
 real,parameter   :: max_dist=20.0
 integer          :: i,direction
 real             :: rmin,rmax,r,dx,dy,dl
 real             :: Ex,Ey,E
 do direction = -1,1,2              !direction= +/- 1
  dl = direction * step
  x0 = xin
  y0 = yin
  dx = 0.0
  dy = 0.0
  call mdist(x0,y0,X,Y,N,rmin,rmax)
  do while(rmin .gt. (2.0*step) .and. rmax .lt. max_dist)
   print *,x0,y0
!  We evaluate the E-field at the midpoint: This reduces
!  systematic errors 
   call efield(x0+0.5*dx,y0+0.5*dy,X,Y,Q,N,Ex,Ey)
   E  = sqrt(Ex*Ex+Ey*Ey)
   if( E .le. 1.0e-10 ) exit
   dx = dl*Ex/E
   dy = dl*Ey/E
   x0 = x0 + dx
   y0 = y0 + dy
   call mdist(x0,y0,X,Y,N,rmin,rmax)
  enddo                    !do while()
 enddo                     !do direction = -1,1,2
end subroutine eline
!****************************************************
subroutine efield(x0,y0,X,Y,Q,N,Ex,Ey)
!****************************************************
 implicit none
 integer           :: N
 real,dimension(N) :: X,Y,Q
 real              :: x0,y0,dx,dy,Ex,Ey
 integer           :: i
 real              :: r3,xi,yi
      
 Ex  = 0.0
 Ey  = 0.0
 do i= 1,N
  xi = x0-X(i)
  yi = y0-Y(i)
! Exercise: Improve code so that xi*xi+yi*yi=0 is taken care of
  r3 = (xi*xi+yi*yi)**(-1.5)
  Ex = Ex + Q(i)*xi*r3
  Ey = Ey + Q(i)*yi*r3
 enddo
end subroutine efield
!****************************************************
subroutine mdist(x0,y0,X,Y,N,rmin,rmax)
!****************************************************
 implicit none
 integer           :: N
 real,dimension(N) :: X,Y
 real              :: x0,y0,rmin,rmax
 integer           :: i
 real              :: r

 rmax = 0.0
 rmin = 1000.0
 do i = 1,N
  r  = sqrt((x0-X(i))**2 + (y0-Y(i))**2)
  if(r.GT.rmax) rmax = r
  if(r.LT.rmin) rmin = r
 enddo
end subroutine mdist
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
