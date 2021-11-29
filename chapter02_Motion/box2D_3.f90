!============================================================
!File box2D_3.f90
!Motion of a free particle in a box  0<x<L 0<y<Ly
!Use analytical solution
!------------------------------------------------------------
program box2D
 implicit none
!------------------------------------------------------------
!Declaration of variables
 real(8) ::  Lx,Ly,x0,y0,v0x,v0y,t0,tf,dt,t,x,y,vx,vy,t0x,t0y
 real(8) :: Thx,Thy,tix,tiy
 integer :: i,nx,ny
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
 if( v0x .ne. 0.0D0) Thx = Lx/DABS(v0x) !Half period in x-direction
 if( v0y .ne. 0.0D0) Thy = Ly/DABS(v0y) !Half period in y-direction
 i  = 0  !step   counter
 nx = 0  !number of x-collisions
 ny = 0  !number of y-collisions
 t  = t0
!---- x init
 x  = x0
 vx = v0x
 if(v0x .gt. 0.0D0)then
  t0x = -x0/v0x
  x0  = 0.0D0
 else if( v0x .lt. 0.0D0)then !skip v0x=0 case
  t0x = (Lx-x0)/v0x
  x0  = Lx
 endif
 tix  = t0x
!---- y init
 y  = y0
 vy = v0y
 if(v0y .gt. 0.0D0)then
  t0y = -y0/v0y
  y0  = 0.0D0
 else if( v0y .lt. 0.0D0)then !skip v0y=0 case
  t0y = (Ly-y0)/v0y
  y0  = Ly
 endif
 tiy  = t0y
! -----
 open(unit=11,file='box2D_3.dat')
!------------------------------------------------------------
!Compute:
 do while(t .le. tf)
  write(11,*)t,x,y,v0x,v0y
  i = i  + 1
  t = t0 + i*dt
!----- hit x-direction
  if( (t-t0x) .gt. Thx )then
   nx  = nx  + 1
   t0x = tix + nx*Thx
   vx  = -vx
   if( vx .gt. 0.0D0)then
    x0 = 0.0D0
   else if(vx .lt. 0.0D0)then
    x0 = Lx
   endif !if( vx .gt. 0.0)
  endif
! ----- hit y-direction
  if( (t-t0y) .gt. Thy )then
   ny  = ny  + 1
   t0y = tiy + ny*Thy
   vy  = -vy
   if( vy .gt. 0.0D0)then
    y0 = 0.0D0
   else if(vy .lt. 0.0D0)then
    y0 = Ly
   endif !if( vy .gt. 0.0)
  endif  !if( (t-t0) .gt. Th )
  x = x0 + vx*(t-t0x)
  y = y0 + vy*(t-t0y)
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
