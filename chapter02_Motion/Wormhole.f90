!============================================================
program WormHole2D
 implicit none
!------------------------------------------------------------
!Declaration of variables
 real(8), parameter :: PI=3.14159265358979324D0
 real(8) ::  Lx,Ly,L,R,d
 real(8) ::  x0,y0,v0,theta
 real(8) ::  t0,tf,dt
 real(8) ::  t,x,y,vx,vy
 real(8) ::  xc1,yc1,xc2,yc2,r1,r2
 integer ::  i
!------------------------------------------------------------
!Ask user for input:
 print *,'# Enter L,d,R:'
 read  *,L,d,R
 print *,'# L= ',L,' d= ',d,' R= ',R
 if( L .le. d+2.0D0*R) stop 'L <= d+2*R'
 if( d .le.   2.0D0*R) stop 'd <=   2*R'
 print *,'# Enter (x0,y0), v0, theta(degrees):'
 read  *,x0,y0,v0,theta
 print *,'# x0= ',x0,' y0   = ',y0
 print *,'# v0= ',v0,' theta= ',theta,' degrees'
 if(v0 .le.   0.0D0  ) stop 'illegal value of v0.'
 print *,'# Enter tf, dt:'
 read  *,tf,dt
 print *,'# tf= ',tf,' dt= ',dt
!------------------------------------------------------------
!Initialize
 theta = (PI/180.0D0)*theta
 i     =  0
 t     =  0.0D0
 x     =  x0           ; y     =  y0
 vx    =  v0*cos(theta); vy    =  v0*sin(theta)
 print *,'# x0= ',x,' y0= ',y,' v0x= ',vx,' v0y= ',vy
!Wormhole's centers:
 xc1   =  0.5D0*d; yc1   =  0.0D0
 xc2   = -0.5D0*d; yc2   =  0.0D0
!Box limits coordinates:
 Lx    =  0.5D0*L; Ly    =  0.5D0*L
!Test if already inside cut region:
 r1    = sqrt((x-xc1)**2+(y-yc1)**2)
 r2    = sqrt((x-xc2)**2+(y-yc2)**2)
 if( r1    .le. R ) stop 'r1 <= R'
 if( r2    .le. R ) stop 'r2 <= R'
!Test if outside box limits:
 if(ABS(x) .ge. Lx) stop '|x| >= Lx' 
 if(ABS(y) .ge. Ly) stop '|y| >= Ly'
 open(unit=11,file='Wormhole.dat')
!------------------------------------------------------------
!Compute:
 do while( t .lt. tf )
  write(11,*)t,x,y,vx,vy
  i  = i+1
  t  = i*dt
  x  = x + vx*dt; y  = y + vy*dt
! Toroidal boundary conditions:
  if( x .gt.  Lx) x  = x - L
  if( x .lt. -Lx) x  = x + L
  if( y .gt.  Ly) y  = y - L
  if( y .lt. -Ly) y  = y + L
! Test if inside the cut disks
  r1 = sqrt((x-xc1)**2+(y-yc1)**2)
  r2 = sqrt((x-xc2)**2+(y-yc2)**2)
  if( r1 .lt. R)then
! Notice: we pass r1 as radius of circle, not R
   call crossC1(x,y,vx,vy,dt,r1,d)
  else if( r2 .lt. R)then
   call crossC2(x,y,vx,vy,dt,r2,d)
  endif
! small chance here that still in C1 or C2, but OK since
! another dt-advance given at the beginning of do-loop
 enddo !do while( t .lt. tf )
end program WormHole2D
! CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
subroutine crossC1(x,y,vx,vy,dt,R,d)
 implicit none
 real(8) ::  x,y,vx,vy,dt,R,d
 real(8) ::  vr,v0 !v0 -> vtheta
 real(8) ::  theta,xc,yc
 print *,'# Inside C1: (x,y,vx,vy,R)= ',x,y,vx,vy,R
 xc    =  0.5D0*d !center of C1
 yc    =  0.0D0
 theta =  atan2(y-yc,x-xc)
 x     = -xc - R*cos(theta) !new x-value, y invariant
!Velocity transformation:
 vr    =  vx*cos(theta)+vy*sin(theta)
 v0    = -vx*sin(theta)+vy*cos(theta)
 vx    =  vr*cos(theta)+v0*sin(theta)
 vy    = -vr*sin(theta)+v0*cos(theta)
!advance x,y, hopefully outside C2: 
 x     = x + vx*dt
 y     = y + vy*dt
 print *,'# Exit   C2: (x,y,vx,vy  )= ',x,y,vx,vy
end subroutine crossC1
! CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
subroutine crossC2(x,y,vx,vy,dt,R,d)
 implicit none
 real(8), parameter :: PI=3.14159265358979324D0
 real(8) ::  x,y,vx,vy,dt,R,d
 real(8) ::  vr,v0 !v0 -> vtheta
 real(8) ::  theta,xc,yc
 
 print *,'# Inside C2: (x,y,vx,vy,R)= ',x,y,vx,vy,R
 xc    = -0.5D0*d !center of C2
 yc    =  0.0D0
 theta =  PI-atan2(y-yc,x-xc)
 x     = -xc + R*cos(theta) !new x-value, y invariant
!Velocity transformation:
 vr    = -vx*cos(theta)+vy*sin(theta)
 v0    =  vx*sin(theta)+vy*cos(theta)
 vx    = -vr*cos(theta)-v0*sin(theta)
 vy    = -vr*sin(theta)+v0*cos(theta)
!advance x,y, hopefully outside C1: 
 x     = x + vx*dt
 y     = y + vy*dt
 print *,'# Exit   C1: (x,y,vx,vy  )= ',x,y,vx,vy
end subroutine crossC2
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
