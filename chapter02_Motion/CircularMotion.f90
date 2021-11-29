! CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
!     File CircularMotion.f
!     Constant angular velocity circular motion
!     Set (x0,y0) and omega.
!     ------------------------------------------------------------
      program CircularMotion
      implicit none
!     ------------------------------------------------------------
!     Declaration of variables
      real x0,y0,R,x,y,vx,vy,t,t0,tf,dt,PI
      real theta,theta0,dtheta_dt,omega
      parameter(PI=3.1415927)
!     ------------------------------------------------------------
!     Ask user for input:
      print *,'# Enter omega:'
      read(5,*)omega
      print *,'# Enter x0,y0:'
      read(5,*)x0,y0
      print *,'# Enter t0,tf,dt:'
      read(5,*)t0,tf,dt
      print *,'# omega= ',omega
      print *,'# x0= ',x0,' y0= ',y0
      print *,'# t0= ',t0,' tf= ',tf,' dt= ',dt
!     ------------------------------------------------------------
!     Initialize
      R      = sqrt(x0*x0+y0*y0)
      if( R .le. 0.0) stop 'Illegal value of R=0'
      theta0 = atan2(y0,x0)
      print *,'# R= ',R,' T= ',2.0*PI/omega,' theta0= ',theta0
      open(unit=11,file='CircularMotion.dat')
!     ------------------------------------------------------------
!     Compute:
      t   =  t0
      do while(t .le. tf)
       theta = theta0 + omega * (t-t0)
       x  =  R*cos(theta)
       y  =  R*sin(theta)
       vx =  -omega*R*sin(theta)
       vy =   omega*R*cos(theta)
       write(11,100)t,x,y,vx,vy,theta,dtheta_dt
       t  =  t + dt
      enddo
      close(11)
 100  FORMAT(7G15.7)
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
