! CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
!     File MiniGolfFriction.f
!     Motion of a free particle in a box  0<x<Lx 0<y<Ly
!     The box is open at x=0 and has a hole at (xc,yc) of radius R
!     Ball is shot at (0,Ly/2) with speed v0m angle theta (degrees)
!     Use integration with time step dt: x = x + vx*dt y=y+vy*dt
!     A friction -k v is added to stop ball.
!     Ball stops in hole (success) or at x=0 (failure)
!     ------------------------------------------------------------
      program MiniGolf
      implicit none
!     ------------------------------------------------------------
!     Declaration of variables
      real*8  Lx,Ly,x0,y0,v0x,v0y,t0,tf,dt,t,x,y,vx,vy
      real*8  v0,theta,xc,yc,R,R2,PI,k,vfac
      integer i,nx,ny
      character*7 result
      parameter(PI=3.14159265358979324D0)
!     ------------------------------------------------------------
!     Ask user for input:
      print *,'# Enter Lx,Ly:'
      read(5,*)Lx,Ly
      print *,'# Lx = ',Lx,' Ly= ',Ly
      if( Lx .le. 0.0) stop 'Lx must be positive.'
      if( Ly .le. 0.0) stop 'Ly must be positive.'
      print *,'# Enter hole position and radius: (xc,yc), R:'
      read(5,*)xc,yc,R
      print *,'# (xc,yc)= ( ',xc,' , ',yc,' ) R= ',R
      print *,'# Enter k, v0, theta(degrees):'
      read(5,*)k, v0,theta
      print *,'# k= ',k,' v0= ',v0,' theta= ',theta,' degrees'
      if(v0        .le. 0.0D0 ) stop 'illegal value of v0.'
      if(ABS(theta).ge. 90.0D0) stop 'illegal value of theta.'
      print *,'# Enter dt:'
      read(5,*)dt
      print *,'# dt= ',dt
      vfac  = 1.0D0 - k*dt
      print *,'# Dissipative factor= ',vfac
      if( vfac .le. 0.0D0) stop 'illegal value of vfac <=0'
!     ------------------------------------------------------------
!     Initialize
      t0 = 0.0D0
      x0 = 0.00001D0
      y0 = Ly/2.0
      R2 = R*R
      theta = (PI/180.0D0)*theta
      v0x   = v0*cos(theta)
      v0y   = v0*sin(theta)
      print *,'# x0= ',x0,' y0= ',y0,' v0x= ',v0x,' v0y= ',v0y
      i  = 0
      nx = 0
      ny = 0
      t  = t0
      x  = x0
      y  = y0
      vx = v0x
      vy = v0y
      open(unit=11,file='MiniGolfFriction.dat')
!     ------------------------------------------------------------
!     Compute:
      result = 'Failure'
      do while( vfac .ge. 1.0D-3 ) !Until speed reduces by 1000
       write(11,*)t,x,y,vx,vy
       i    = i  + 1
       t    = t0 + i *dt
       x    = x  + vx*dt
       y    = y  + vy*dt
       vx   = vfac*v0x
       vy   = vfac*v0y
       vfac = vfac*(1.0D0-k*dt)
!      print *,'vfac= ',vfac
       if(x .gt. Lx) then
        vx  = -vx
        nx  =  nx + 1
       endif 
       if(y .lt. 0.0 .or. y .gt. Ly) then
        vy  = -vy
        ny  =  ny + 1
       endif
       if(x .le. 0.0D0)then
        result = 'Failure'
        goto 11
       endif
       if( ((x-xc)*(x-xc)+(y-yc)*(y-yc)) .le. R2)then
        result = 'Success'
        goto 11
       endif
      enddo
 11   continue !break loop here
      close(11)
      print *,'# Number of collisions:'
      print *,'# Result= ',result,' nx= ',nx,' ny= ',ny
      print *,'# n = ',i ,' t = ',t,' x= ',x, '  y= ',y
      print *,'#                     vx= ',vx,' vy= ',vy
      end
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
