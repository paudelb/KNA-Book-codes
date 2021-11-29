!================================================================
!File ProjectileAirResistance.f90
!Shooting a progectile near the earth surface with air resistance
!Starts at (0,0), set k, (v0,theta).
!----------------------------------------------------------------
program ProjectileAirResistance
 implicit none
!------------------------------------------------------------
!Declaration of variables
 real :: x0,y0,R,x,y,vx,vy,t,tf,dt,k
 real :: theta,v0x,v0y,v0
 real, parameter :: PI=3.1415927,g=9.81
!------------------------------------------------------------
!Ask user for input:
 print *,'# Enter k, v0,theta (in degrees):'
 read  *,k, v0,theta
 print *,'# Enter tf,dt:'
 read  *, tf,dt
 print *,'# k = ',k
 print *,'# v0= ',v0,' theta= ',theta,'o (degrees)'
 print *,'# t0= ',0.0,' tf= ',tf,' dt= ',dt
!------------------------------------------------------------
!Initialize
 if( v0    .le. 0.0) stop 'Illegal value of v0<=0'
 if( k     .le. 0.0) stop 'Illegal value of k <=0'
 if( theta .le. 0.0 .or. theta .ge. 90.0) &
      stop 'Illegal value of theta'
 theta  = (PI/180.0)*theta !convert to radians
 v0x    = v0*cos(theta)
 v0y    = v0*sin(theta)
 print *,'# v0x = ',v0x,' v0y= ',v0y
 open(unit=11,file='ProjectileAirResistance.dat')
!------------------------------------------------------------
!Compute:
 t   =  0.0
 do while(t .le. tf)
  x  =  (v0x/k)*(1.0-exp(-k*t))
  y  =  (1.0/k)*(v0y+(g/k))*(1.0-exp(-k*t))-(g/k)*t
  vx =  v0x*exp(-k*t)
  vy =  (v0y+(g/k))*exp(-k*t)-(g/k)
  write(11,*)t,x,y,vx,vy
  t  =  t + dt
 enddo
 close(11)
end program ProjectileAirResistance
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
