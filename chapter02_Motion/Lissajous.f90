!================================================================
!File Lissajous.f90
!Lissajous curves (special case) x(t)= cos(o1 t), y(t)= sin(o2 t) 
!----------------------------------------------------------------
program Lissajous
 implicit none
!------------------------------------------------------------
!Declaration of variables
 real x0,y0,R,x,y,vx,vy,t,t0,tf,dt
 real o1,o2,T1,T2
 real, parameter :: PI=3.1415927
!------------------------------------------------------------
!Ask user for input:
 print *,'# Enter omega1 and omega2:'
 read  *,o1,o2
 print *,'# Enter tf,dt:'
 read  *,tf,dt
 print *,'# o1= ',o1, ' o2= ',o2
 print *,'# t0= ',0.0,' tf= ',tf,' dt= ',dt
!------------------------------------------------------------
!Initialize
 if(o1.le.0.0 .or. o2.le.0.0) stop 'Illegal omega1 or omega2<=0'
 T1 = 2.0*PI/o1
 T2 = 2.0*PI/o2
 print *,'# T1= ',T1,' T2= ',T2
 open(unit=11,file='Lissajous.dat')
!------------------------------------------------------------
!Compute:
 t   =  0.0
 do while(t .le. tf)
  x  =  cos(o1*t)
  y  =  sin(o2*t)
  vx = -o1*sin(o1*t)
  vy =  o2*cos(o2*t)
  write(11,*)t,x,y,vx,vy
  t  =  t + dt
 enddo
 close(11)
end program Lissajous
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
