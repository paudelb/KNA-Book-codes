!============================================================
!File box1D_4.f90
!Motion of a free particle in a box  0<x<L
!Use integration with time step dt: x = x + v*dt
!Improve accuracy in t
!------------------------------------------------------------
program box1D
 implicit none
!------------------------------------------------------------
!Declaration of variables
 real    :: L,x0,v0,t0,tf,dt,t,x,v
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
 x = x0
 v = v0
 i = 0
 open(unit=11,file='box1D_4.dat')
!------------------------------------------------------------
!Compute:
 do while(t .le. (tf+1.0E-5))
  write(11,*)t,x,v
  i = i  + 1
  x = x  + v*dt
  t = t0 + i*dt
  if(x .lt. 0.0 .or. x .gt. L) v = -v
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
