!===========================================================
!File ChargeInB.f90
!A charged particle of mass m and charge q enters a magnetic
!field B in +z direction. It enters with velocity 
!v0x=0,v0y=v0 cos(theta),v0z=v0 sin(theta), 0<=theta<pi/2
!at the position x0=-v0y/omega, omega=q B/m
!
!Enter v0 and theta and see trajectory from 
!t0=0 to tf at step dt
!------------------------------------------------------------
program ChargeInB
 implicit none
!------------------------------------------------------------
!Declaration of variables
 real :: x,y,z,vx,vy,vz,t,tf,dt
 real :: x0,y0,z0,v0x,v0y,v0z,v0
 real :: theta,omega
 real, parameter :: PI=3.1415927
!------------------------------------------------------------
!Ask user for input:
 print *,'# Enter omega: '
 read  *,omega
 print *,'# Enter v0, theta (degrees):'
 read  *,v0,theta
 print *,'# Enter tf,dt:'
 read  *,tf,dt
 print *,'# omega=  ',omega ,' T=     ',2.0*PI/omega
 print *,'# v0=     ',v0,    ' theta= ',theta,'o (degrees)'
 print *,'# t0=     ',0.0,   ' tf=    ',tf,' dt= ',dt
!------------------------------------------------------------
!Initialize
 if(theta.lt.0.0 .or. theta.ge.90.0)stop 'Illegal 0<theta<90'
 theta = (PI/180.0)*theta !convert to radians
 v0y   = v0*cos(theta)
 v0z   = v0*sin(theta)
 print *,'# v0x= ',0.0,' v0y= ',v0y,' v0z= ',v0z
 x0    = - v0y/omega
 print *,'# x0=  ',x0, ' y0=  ',0.0,' z0=  ',0.0
 print *,'# xy plane: Circle with center (0,0) and R= ',ABS(x0)
 print *,'# step of helix: s=v0z*T= ',v0z*2.0*PI/omega
 open(unit=11,file='ChargeInB.dat')
!------------------------------------------------------------
!Compute:
 t   = 0.0
 vz  = v0z
 do while(t .le. tf)
  x  =  x0*cos(omega*t)
  y  = -x0*sin(omega*t)
  z  =  v0z*t
  vx =  v0y*sin(omega*t)
  vy =  v0y*cos(omega*t)
  write(11,100)t,x,y,z,vx,vy,vz
  t  =  t + dt
 enddo
 close(11)
100 FORMAT(20G15.7)
end program ChargeInB
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
