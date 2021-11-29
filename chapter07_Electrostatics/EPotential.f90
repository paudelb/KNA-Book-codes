!****************************************************
program Electric_Potential
!****************************************************
 implicit none
 integer,parameter :: P=20     !max number of charges
 real,dimension(P) :: X,Y,Q
 integer           :: N
 real,parameter    :: PI= 3.14159265359
 integer           :: i,j,nd
 real              :: x0,y0,rmin,rmax,L

 print *, '# Enter number of charges:'
 read  *,   N
 print *, '# N= ',N
 do i=1,N
  print *,'# Charge: ',i
  print *,'# Position and charge: (X,Y,Q):'
  read  *,  X(i),Y(i),Q(i)
  print *,'# (X,Y)= ', X(i),Y(i), ' Q= ',Q(i)
 enddo     
!-------------  DRAWING LINES  -------------
!We draw lines passing through an equally 
!spaced lattice of N=(2*nd+1)x(2*nd+1) points
!in the square -L<= x <= L, -L<= y <= L.
 nd    = 4
 L     = 1.0
 do  i = -nd,nd
  do j = -nd,nd
   x0  = i*(L/nd)
   y0  = j*(L/nd)
   print *,'# @ ',i,j,L/nd,x0,y0
   call  mdist(x0,y0,X,Y,N,rmin,rmax)
!we avoid getting too close to a charge:
   if(rmin .gt. L/(nd*10) )&
        call  epotline(x0,y0,X,Y,Q,N)
  enddo
 enddo
end program Electric_Potential
!****************************************************
subroutine epotline(xin,yin,X,Y,Q,N)
!****************************************************
 implicit none
 integer           :: N
 real,dimension(N) :: X,Y,Q
 real              :: xin,yin,x0,y0
 real,parameter    :: step=0.02
 real,parameter    :: max_dist=20.0
 integer           :: i
 real              :: r,dx,dy,dl
 real              :: Ex,Ey,E

 dl = step
 x0 = xin
 y0 = yin
 dx = 0.0
 dy = 0.0
 r  = step                 !in order to start loop 
 do while( r .gt. (0.9*dl) .and. r .lt. max_dist)
  print *,x0,y0
! We evaluate the E-field at the midpoint: This reduces
! systematic errors 
  call efield(x0+0.5*dx,y0+0.5*dy,X,Y,Q,N,Ex,Ey)
  E  = sqrt(Ex*Ex+Ey*Ey)
  if( E .le. 1.0e-10 ) exit
  dx =  dl*Ey/E
  dy = -dl*Ex/E
  x0 = x0 + dx
  y0 = y0 + dy
  r  = sqrt((x0-xin)**2+(y0-yin)**2)
 enddo                     !do while()
end subroutine epotline
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
