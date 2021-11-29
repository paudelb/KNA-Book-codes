!==============================================================
!File SimplePendulum.f90
!Set pendulum original position at theta0 with no initial speed
!--------------------------------------------------------------
program SimplePendulum
 implicit none
!------------------------------------------------------------
!Declaration of variables
 real :: l,x,y,vx,vy,t,t0,tf,dt
 real :: theta,theta0,dtheta_dt,omega
 real, parameter ::PI=3.1415927,g=9.81
!------------------------------------------------------------
!Ask user for input:
 print *,'# Enter l: '
 read  *,l
 print *,'# Enter theta0:'
 read  *,theta0
 print *,'# Enter t0,tf,dt:'
 read  *,t0,tf,dt
 print *,'# l=  ',l ,' theta0= ',theta0
 print *,'# t0= ',t0,' tf= ',tf,' dt= ',dt
!------------------------------------------------------------
!Initialize
 omega = sqrt(g/l)
 print *,'# omega= ',omega,' T= ',2.0*PI/omega
 open(unit=11,file='SimplePendulum.dat')
!------------------------------------------------------------
!Compute:
 t   =  t0
 do while(t .le. tf)
  theta     =        theta0*cos(omega*(t-t0))
  dtheta_dt = -omega*theta0*sin(omega*(t-t0))
  x  =  l*sin(theta)
  y  = -l*cos(theta)
  vx =  l*dtheta_dt*cos(theta)
  vy =  l*dtheta_dt*sin(theta)
  write(11,100)t,x,y,vx,vy,theta,dtheta_dt
  t  =  t + dt
 enddo
 close(11)
100 FORMAT(7G15.7)
end program SimplePendulum
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
