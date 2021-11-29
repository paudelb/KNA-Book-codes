!CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
!Program to compute basin of attraction of
!a Forced Damped Pendulum
!using 4th order Runge-Kutta Method
!A number of steps using RK4 is performed and the sign
!of angular velocity is printed on stdout
!CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC

      program fdp_solve
      implicit none
      integer P
      parameter(P=1010000)
      real*8 T0,TF,X10,X20
      integer STEPS,PSIZE
      real*8 T(P),X1(P),X2(P)
      real*8 Energy
      real*8         omega_0,omega,gamma,a_0,omega_02,omega2
      common /params/omega_0,omega,gamma,a_0,omega_02,omega2
      integer i,Nstart
      real *8 PI2,PI4,PI
      parameter(PI2=6.283185307179D0,PI4=2.0D0*PI2,PI=PI2/2.0D0)

      omega_0  = 1.0D0
      omega    = 2.0D0
      omega_02 = omega_0*omega_0
      omega2   = omega  *omega
      gamma    = 0.2D0
      STEPS    = 10000
      T0       = 0.0D0
      TF       = 200.0D0
      print *, '# Enter A and no of initial conditions:'
      read  *, a_0, Nstart
!The Calculation:
      PSIZE=P

      do i = 1, Nstart
! Random initial conditions with -PI<theta<PI, -2 PI<dtheta/dt<2 PI
       X10 = PI2*(rand()-0.5D0)
       X20 = PI4*(rand()-0.5D0)
!  X10 = PI *rand()
!  X20 = PI2*rand()
       call RK(T,X1,X2,T0,TF,X10,X20,STEPS,PSIZE)
       if( X2(STEPS) .GT. 0.0D0)then
        print *,X10,X20,1
       else
        print *,X10,X20,-1
       endif
      enddo

      end

!CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
!The functions f1,f2(t,x1,x2) provided by the user
!CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      real*8 function f1(t,x1,x2)
      implicit none
      real*8 t,x1,x2
      f1=x2           !dx1/dt= v = x2
      end

      real*8 function f2(t,x1,x2)
      implicit none
      real*8         omega_0,omega,gamma,a_0,omega_02,omega2
      common /params/omega_0,omega,gamma,a_0,omega_02,omega2
      real*8 t,x1,x2
      f2=-(omega_02+2.0D0*a_0*dcos(omega*t))*dsin(x1)-gamma*x2
      end

!CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
!RK(T,X1,X2,T0,TF,X10,X20,STEPS,PSIZE) is the driver 
!for the Runge-Kutta integration routine RKSTEP
!Input: Initial and final times T0,T1
!       Initial values at t=T0  X10,X20
!       Number of steps of integration STEPS
!       Size of arrays T,X1,X2
!Output: real arrays T(PSIZE),X1(PSIZE),X2(PSIZE) where
!T(1) = T0 X1(1) = X10 X2(1) = X20
!          X1(i) = X1(at t=T(i)) X2(i) = X2(at t=T(i))
!T(STEPS+1)=TF
!Therefore we must have PSIZE>STEPS
!CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine RK(T,X1,X2,T0,TF,X10,X20,STEPS,PSIZE)
      implicit none
      integer STEPS,PSIZE
      real*8 T(PSIZE),X1(PSIZE),X2(PSIZE),T0,TF,X10,X20
      real*8 dt         
      real*8 TS,X1S,X2S !values of time and X1,X2 at given step
      integer i

!Some checks:
      if(STEPS .le. 1 )then
       print *,'rk: STEPS must be >= 1'
       stop
      endif
      if(STEPS .ge. PSIZE)then
       print *,'rk: STEPS must be < ',PSIZE
       stop
      endif

!Initialize variables:
      dt    = (TF-T0)/STEPS
      T (1) = T0
      X1(1) = X10
      X2(1) = X20
      TS    = T0
      X1S   = X10
      X2S   = X20
!Make RK steps: The arguments of RKSTEP are replaced with the new ones!
      do i=2,STEPS+1
       call RKSTEP(TS,X1S,X2S,dt)
       T(i)  = TS
       X1(i) = X1S
       X2(i) = X2S
      enddo

      end

      
!CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
!Subroutine RKSTEP(t,x1,x2,dt)
!Runge-Kutta Integration routine of ODE
!dx1/dt=f1(t,x1,x2) dx2/dt=f2(t,x1,x2)
!User must supply derivative functions:
!real function f1(t,x1,x2)
!real Function f2(t,x1,x2) 
!Given initial point (t,x1,x2) the routine advnaces it
!by time dt.
!Input : Inital time t    and function values x1,x2
!Output: Final  time t+dt and function values x1,x2
!Careful!: values of t,x1,x2 are overwritten...
!CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine RKSTEP(t,x1,x2,dt)
      implicit none
      real*8 t,x1,x2,dt
      real*8 f1,f2
      real*8 k11,k12,k13,k14,k21,k22,k23,k24
      real*8 h,h2,h6,pi,pi2
      parameter(pi =3.14159265358979324D0)
      parameter(pi2=6.28318530717958648D0)

      h=dt                         !h =dt, integration step
      h2=0.5D0*h                     !h2=h/2
      h6=0.166666666666666666666666D0*h  !h6=h/6
      
      k11=f1(t,x1,x2)
      k21=f2(t,x1,x2)
      k12=f1(t+h2,x1+h2*k11,x2+h2*k21)
      k22=f2(t+h2,x1+h2*k11,x2+h2*k21)
      k13=f1(t+h2,x1+h2*k12,x2+h2*k22)
      k23=f2(t+h2,x1+h2*k12,x2+h2*k22)
      k14=f1(t+h ,x1+h *k13,x2+h *k23)
      k24=f2(t+h ,x1+h *k13,x2+h *k23)

      t =t+h
      x1=x1+h6*(k11+2.0D0*(k12+k13)+k14)
      x2=x2+h6*(k21+2.0D0*(k22+k23)+k24)
      if( x1 .gt.  pi) x1 = x1 - pi2
      if( x1 .lt. -pi) x1 = x1 + pi2
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
