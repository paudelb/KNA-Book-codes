!============================================================
!File box2D_2.f90
!Motion of a free particle in a box  0<x<L 0<y<Ly
!Use constant velocity equation: x = x0 + v0x*(t-t0)
!                                y = y0 + v0y*(t-t0)
!Reverse velocity and redefine x0,t0x,y0,t0y on boundaries
!------------------------------------------------------------
program box2D
 implicit none
!------------------------------------------------------------
!Declaration of variables
 real(8)  ::  Lx,Ly,x0,y0,v0x,v0y,t0,tf,dt,t,x,y,vx,vy,t0x,t0y
 real(8)  ::  Thx,Thy
 integer  ::  i,nx,ny
!------------------------------------------------------------
!Ask user for input:
 print *,'# Enter Lx,Ly:'
 read  *,Lx,Ly
 print *,'# Lx = ',Lx,' Ly= ',Ly
 if( Lx .le. 0.0) stop 'Lx must be positive.'
 if( Ly .le. 0.0) stop 'Ly must be positive.'
 print *,'# Enter x0,y0,v0x,v0y:'
 read  *,x0,y0,v0x,v0y
 print *,'# x0= ',x0,' y0= ',y0,' v0x= ',v0x,' v0y= ',v0y
 if(x0 .lt. 0.0 .or. x0 .gt. Lx) stop 'illegal value of x0.'
 if(y0 .lt. 0.0 .or. y0 .gt. Ly) stop 'illegal value of y0.'
 if(v0x**2+v0y**2.eq. 0.0D0    ) stop 'illegal value of v0 = 0.'
 print *,'# Enter t0,tf,dt:'
 read  *,t0,tf,dt
 print *,'# t0= ',t0,' tf= ',tf,' dt= ',dt
!------------------------------------------------------------
!Initialize
 i  = 0  !step   counter
 nx = 0  !number of x-collisions
 ny = 0  !number of y-collisions
 t  = t0
 t0x= t0
 t0y= t0
 x  = x0
 y  = y0
 vx = v0x
 vy = v0y
 if( v0x .ne. 0.0D0) Thx = Lx/DABS(v0x) !Half period in x-direction
 if( v0y .ne. 0.0D0) Thy = Ly/DABS(v0y) !Half period in y-direction
 open(unit=11,file='box2D_2.dat')
!------------------------------------------------------------
!Compute:
 do while(t .le. tf)
  x = x0 + v0x*(t-t0x)
  y = y0 + v0y*(t-t0y)
  write(11,*)t,x,y,v0x,v0y
!------------------------- hit left
  if( x .lt. 0.0D0) then 
   x0    = 0.0D0
   t0x   = t
   v0x   = -v0x
   nx    = nx + 1
  endif
!------------------------- hit right
  if( x .gt. Lx)then
   x0   = Lx
   t0x  = t
   v0x  = -v0x
   nx   = nx + 1
  endif
!------------------------- hit down
  if( y .lt. 0.0D0)then
   y0   = 0.0D0
   t0y  =  t
   v0y  = -v0y
   ny   = ny + 1
  endif
!------------------------- hit up
  if( y .gt. Ly)then
   y0   = Ly
   t0y  = t
   v0y  = -v0y
   ny   = ny + 1
  endif
!------------------------- end hits
  i     =  i  + 1
  t     =  t0 + i*dt
 enddo
 close(11)
 print *,'# Number of collisions:'
 print *,'# nx= ',nx,' ny= ',ny
end program box2D
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
