!============================================================
!File box1D_3.f90
!Motion of a free particle in a box  0<x<L
!Computation of analytical solution
!------------------------------------------------------------
program box1D
 implicit none
!------------------------------------------------------------
!Declaration of variables
 real :: L,x0,v0,t0,tf,dt,t,x,v,Th,a
!------------------------------------------------------------
!Ask user for input:
 print *,'# Enter L:'
 read  *,L
 print *,'# L = ',L
 if( L .le. 0.0) stop 'L must be positive.'
 print *,'# Enter x0,v0:'
 read  *, a,v0 !notice, x0=a is the original position
 print *,'# x0= ',a ,' v0= ',v0
 if(a  .lt. 0.0 .or. a  .gt. L) stop 'illegal value of x0.'
 if(v0 .eq. 0.0               ) stop 'illegal value of v0 = 0.' 
 print *,'# Enter t0,tf,dt:'
 read  *,t0,tf,dt
 print *,'# t0= ',t0,' tf= ',tf,' dt= ',dt
!------------------------------------------------------------
!Initialize
 Th  = L/ABS(v0) !Th = T/2 = half period
 t   = t0
 x   = a
 v   = v0
 if( v0 .gt. 0.0 ) then
  t0 = -a/v0
  x0 =  0.0
 else
  t0 = (L-a)/v0
  x0 =  L
 endif
 open(unit=11,file='box1D_3.dat')
!------------------------------------------------------------
!Compute:
 do while(t .le. tf)
  write(11,*)t,x,v
  t = t + dt
  if( (t-t0) .gt. Th )then
   t0 = t0 + Th
   v  = -v
   if( v .gt. 0.0)then
    x0 = 0.0
   else
    x0 = L
   endif !if( v .gt. 0.0)
  endif  !if( (t-t0) .gt. Th )
  x = x0 + v*(t-t0)
 enddo   !do while(t .le. tf)
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
