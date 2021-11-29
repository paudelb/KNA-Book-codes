!============================================================
!File Circle.f90
!Constant angular velocity circular motion
!Set (x0,y0) center of circle, its radius R and omega.
!At t=t0, the particle is at theta=0
!------------------------------------------------------------
program Circle
 implicit none
!------------------------------------------------------------
!Declaration of variables
 real :: x0,y0,R,x,y,vx,vy,t,t0,tf,dt
 real :: theta,omega
 real, parameter :: PI=3.1415927
!------------------------------------------------------------
!Ask user for input:
 print *,'# Enter omega:'
 read  *,omega
 print *,'# Enter center of circle (x0,y0) and radius R:'
 read  *,x0,y0,R
 print *,'# Enter t0,tf,dt:'
 read  *,t0,tf,dt
 print *,'# omega= ',omega
 print *,'# x0= ',x0,' y0= ',y0,' R= ',R
 print *,'# t0= ',t0,' tf= ',tf,' dt= ',dt
!------------------------------------------------------------
!Initialize
 if(R     .le. 0.0) stop 'Illegal value of R'
 if(omega .le. 0.0) stop 'Illegal value of omega'
 print *,'# T= ',2.0*PI/omega
 open(unit=11,file='Circle.dat')
!------------------------------------------------------------
!Compute:
 t   =  t0
 do while(t .le. tf)
  theta = omega * (t-t0)
  x  =  x0+R*cos(theta)
  y  =  y0+R*sin(theta)
  vx =  -omega*R*sin(theta)
  vy =   omega*R*cos(theta)
  write(11,*)t,x,y,vx,vy
  t  =  t + dt
 enddo
 close(11)
end program Circle
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
