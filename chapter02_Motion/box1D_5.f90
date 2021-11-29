!============================================================
!File box1D_5.f90
!Motion of a free particle in a box  0<x<L
!Use constant velocity equation: x = x0 + v0*(t-t0)
!Reverse velocity and redefine x0,t0 on boundaries
!------------------------------------------------------------
program box1D
 implicit none
!------------------------------------------------------------
!Declaration of variables
 real    :: L,x0,v0,t0,tf,dt,t,x,v,ti
 integer :: i
!------------------------------------------------------------
!Ask user for input:
 print *,'# Enter L:'
 read  *,L
 print *,'# L = ',L
 if( L .le. 0.0) stop 'L must be positive.'
 print *,'# Enter x0,v0:'
 read  *,x0,v0
 print *,'# x0= ',x0,' v0= ',v0
 if(x0 .lt. 0.0 .or. x0 .gt. L) stop 'illegal value of x0.'
 if(v0 .eq. 0.0               ) stop 'illegal value of v0 = 0.'
 print *,'# Enter t0,tf,dt:'
 read  *,t0,tf,dt
 print *,'# t0= ',t0,' tf= ',tf,' dt= ',dt
!------------------------------------------------------------
!Initialize
 t = t0
 ti= t0
 i = 0
 open(unit=11,file='box1D_5.dat')
!------------------------------------------------------------
!Compute:
 do while(t .le. (tf+1.0E-5))
  x = x0 + v0*(t-t0)
  write(11,*)t,x,v0
  if( x .lt. 0.0 .or. x .gt. L)then
   x0 =  x
   t0 =  t
   v0 = -v0
  endif
  i   =  i  + 1
  t   =  ti + i*dt
 enddo
 close(11)
end program box1D
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
