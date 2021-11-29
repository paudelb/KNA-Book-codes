!============================================================
!File MiniGolf.f
!Motion of a free particle in a box  0<x<Lx 0<y<Ly
!The box is open at x=0 and has a hole at (xc,yc) of radius R
!Ball is shot at (0,Ly/2) with speed v0, angle theta (degrees)
!Use integration with time step dt: x = x + vx*dt y=y+vy*dt
!Ball stops in hole (success) or at x=0 (failure)
!------------------------------------------------------------
program MiniGolf
 implicit none
!------------------------------------------------------------
!Declaration of variables
 real(8)            ::  Lx,Ly,x0,y0,v0x,v0y,t0,tf,dt,t,x,y,vx,vy
 real(8)            ::  v0,theta,xc,yc,R,R2
 real(8), parameter :: PI=3.14159265358979324D0
 integer            ::  i,nx,ny
 character(7)       :: result
!------------------------------------------------------------
!Ask user for input:
 print *,'# Enter Lx,Ly:'
 read  *,Lx,Ly
 print *,'# Lx = ',Lx,' Ly= ',Ly
 if( Lx .le. 0.0) stop 'Lx must be positive.'
 if( Ly .le. 0.0) stop 'Ly must be positive.'
 print *,'# Enter hole position and radius: (xc,yc), R:'
 read  *,xc,yc,R
 print *,'# (xc,yc)= ( ',xc,' , ',yc,' ) R= ',R
 print *,'# Enter v0, theta(degrees):'
 read  *,v0,theta
 print *,'# v0= ',v0,' theta= ',theta,' degrees'
 if(v0        .le. 0.0D0 ) stop 'illegal value of v0.'
 if(ABS(theta).ge. 90.0D0) stop 'illegal value of theta.'
 print *,'# Enter dt:'
 read  *,dt
 print *,'# dt= ',dt
!------------------------------------------------------------
!Initialize
 t0 = 0.0D0
 x0 = 0.00001D0 ! small but non-zero
 y0 = Ly/2.0
 R2 = R*R
 theta = (PI/180.0D0)*theta
 v0x = v0*cos(theta)
 v0y = v0*sin(theta)
 print *,'# x0= ',x0,' y0= ',y0,' v0x= ',v0x,' v0y= ',v0y
 i  = 0
 nx = 0  ;  ny = 0
 t  = t0
 x  = x0 ;  y  = y0
 vx = v0x;  vy = v0y
 open(unit=11,file='MiniGolf.dat')
!------------------------------------------------------------
!Compute:
 do while( .TRUE. ) !forever!
  write(11,*)t,x,y,vx,vy
  i = i  + 1
  t = t0 + i*dt
  x = x  + vx*dt
  y = y  + vy*dt
  if(x .gt. Lx) then
   vx = -vx
   nx =  nx + 1
  endif
  if(y .lt. 0.0 .or. y .gt. Ly) then
   vy = -vy
   ny = ny  + 1
  endif
  if(x .le. 0.0D0)then
   result = 'Failure'
   exit !exit do loop
  endif
  if( ((x-xc)*(x-xc)+(y-yc)*(y-yc)) .le. R2)then
   result = 'Success'
   exit !exit do loop
  endif
 enddo
 close(11)
 print *,'# Number of collisions:'
 print *,'# Result= ',result,' nx= ',nx,' ny= ',ny
end program MiniGolf
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
