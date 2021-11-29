!============================================================
!File box2D_1.f90
!Motion of a free particle in a box  0<x<Lx 0<y<Ly
!Use integration with time step dt: x = x + vx*dt y=y+vy*dt
!------------------------------------------------------------
program box2D
 implicit none
!------------------------------------------------------------
!Declaration of variables
 real(8) ::  Lx,Ly,x0,y0,v0x,v0y,t0,tf,dt,t,x,y,vx,vy
 integer ::  i,nx,ny
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
 if(v0x**2+v0y**2.eq. 0.0      ) stop 'illegal value of v0 = 0.'
 print *,'# Enter t0,tf,dt:'
 read  *,t0,tf,dt
 print *,'# t0= ',t0,' tf= ',tf,' dt= ',dt
!------------------------------------------------------------
!Initialize
 i  = 0
 nx = 0  ;  ny = 0
 t  = t0
 x  = x0 ;  y  = y0
 vx = v0x;  vy = v0y
 open(unit=11,file='box2D_1.dat')
!------------------------------------------------------------
!Compute:
 do while(t .le. tf)
  write(11,*)t,x,y,vx,vy
  i = i  + 1
  t = t0 + i *dt
  x = x  + vx*dt
  y = y  + vy*dt
  if(x .lt. 0.0 .or. x .gt. Lx) then
   vx = -vx
   nx =  nx + 1
  endif
  if(y .lt. 0.0 .or. y .gt. Ly) then
   vy = -vy
   ny =  ny + 1
  endif
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
