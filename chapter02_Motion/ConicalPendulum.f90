!============================================================
!File ConicalPendulum.f90
!Set pendulum angular velocity omega and display motion in 3D
!------------------------------------------------------------
program ConicalPendulum
 implicit none
!------------------------------------------------------------
!Declaration of variables
 real :: l,r,x,y,z,vx,vy,vz,t,tf,dt
 real :: theta,cos_theta,sin_theta,omega
 real, parameter :: PI=3.1415927,g=9.81
!------------------------------------------------------------
!Ask user for input:
 print *,'# Enter l,omega: '
 read  *,l,omega
 print *,'# Enter tf,dt:'
 read  *,tf,dt
 print *,'# l=  ',l           ,' omega=     ',omega
 print *,'# T=  ',2.0*PI/omega,' omega_min= ',sqrt(g/l)
 print *,'# t0= ',0.0,' tf= ',tf,' dt= ',dt
!------------------------------------------------------------
!Initialize
 cos_theta = g/(omega*omega*l)
 if( cos_theta .ge. 1) stop 'cos(theta)>= 1'
 sin_theta = sqrt(1.0-cos_theta*cos_theta)
 z = -g/(omega*omega) !they remain constant throught
 vz= 0.0              !the  motion
 r =  g/(omega*omega)*sin_theta/cos_theta
 open(unit=11,file='ConicalPendulum.dat')
!------------------------------------------------------------
!Compute:
 t   = 0.0
 do while(t .le. tf)
  x  =  r*cos(omega*t)
  y  =  r*sin(omega*t)
  vx = -r*sin(omega*t)*omega
  vy =  r*cos(omega*t)*omega
  write(11,100)t,x,y,z,vx,vy,vz
  t  =  t + dt
 enddo
 close(11)
100 FORMAT(20G15.7)
end program ConicalPendulum
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
