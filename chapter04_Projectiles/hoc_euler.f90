!CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
!Program to integrate equations of motion for accelerations
!which are functions of x with the method of Euler, Euler-Cromer
!and Euler-Verlet.
!The user sets initial conditions and the subroutines return
!X(t) and V(t)=dX(t)/dt in arrays T(1..STEPS),X(1..STEPS),V(1..STEPS)
!The user provides number of integration STEPS and the final
!time TFI.Initial time is assumed to be t_0=0 and the integration
!step h = TFI/(STEPS-1) 
!The user programs a real function accel(x) which gives the 
!acceleration  dV(t)/dt as function of X.
!NOTE: T(1) = 0 T(STEPS) = TFI and there are STEPS-1 aditional
!      steps after the initial point
!CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      program diff_eq_euler
      implicit none             ! We force ourselved to declare all variables
      integer P                 ! The size of the arrays, should be larger
      parameter(P=110000)       ! than number of steps
      real*8 T(P),X(P),V(P)       ! time t,x(t),v(t)=dx/dt
      real*8 Xin,Vin,Tfi          ! initial conditions
      real*8 Energy
      integer steps,i
      !t_0 = 0.0

!The user provides initial conditions X_0,V_0 final time t_f and
!number of steps:
      print *,'Enter X_0,V_0,t_f,number of steps (t_0=0):'
      read  *,Xin,Vin,Tfi,steps
!This check is necessary to avoid memory violations:
      if(steps .ge. p )then 
       print *,'steps must be strictly less than p. steps,p= ',steps,p
       stop
      endif

!Xin= X(1), Vin=V(1), T(1)=0 and the routine gives eveolution in
!T(2..STEPS), X(2..STEPS), V(2..STEPS) which we print in a file
      call euler(Xin,Vin,Tfi,steps,T,X,V)
      open(unit=20,file="euler.dat") !filename euler.dat given here
      do i=1,steps
!Each line in data file has time, position, velocity:
       Energy = 0.5D0*V(i)*V(i)+0.5D0*10.0D0*X(i)*X(i)
       write(20,*) T(i),X(i),V(i),Energy 
      enddo
      close(20) !we close the unit to be reused below

!We repeat everything for each method
      call euler_cromer(Xin,Vin,Tfi,steps,T,X,V)
      open(unit=20,file="euler_cromer.dat")
      do i=1,steps
       Energy = 0.5D0*V(i)*V(i)+0.5D0*10.0D0*X(i)*X(i)
       write(20,*) T(i),X(i),V(i),Energy 
      enddo
      close(20)
      
      call euler_verlet(Xin,Vin,Tfi,steps,T,X,V)
      open(unit=20,file="euler_verlet.dat")
      do i=1,steps
       Energy = 0.5D0*V(i)*V(i)+0.5D0*10.0D0*X(i)*X(i)
       write(20,*) T(i),X(i),V(i),Energy 
      enddo
      close(20)

      end


!CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
!Function which returns the value of acceleration at
!position x used in the integration subroutines
!euler, euler_cromer and euler_verlet
!CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      real*8 function accel(x)
      implicit none
      real*8 x
      accel = -10.0D0*x
      end

!CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
!Driver routine for integrating equations of motion 
!using the Euler method
!Input:
!Xin=X(1), Vin=V(1) -- initial condition at t=0,
!Tfi the final time and steps the number of steps of integration
!(the initial point is counted as the first one)
!Output:
!The arrays T(1..steps), X(1..steps), V(1..steps) which 
!gives x(t_i)=X(i), dx/dt(t_i)=V(i), t_i=T(i) i=1..steps
!where for i=1 we have the initial condition.
!CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine euler(Xin,Vin,Tfi,steps,T,X,V)
      implicit none
      integer P
      parameter(P=110000)
      real*8 T(P),X(P),V(P) !time t,x(t),v(t)=dx/dt
      real*8 Xin,Vin,Tfi
      integer steps,i
      real*8 h,accel     !**Note: we have to declare the function accel**
!Initial conditions set here:      
      T(1) = 0.0D0
      X(1) = Xin
      V(1) = Vin
!h is the time step Dt
      h    = Tfi/(steps-1)
      do i = 2,steps
       T(i) = T(i-1)+h          ! time advances by Dt
       X(i) = X(i-1)+V(i-1)*h   ! advancement and storage of position
       V(i) = V(i-1)+accel(X(i-1))*h !... and velocity. Here we call accel(x)
      enddo

      end

!CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
!Driver routine for integrating equations of motion 
!using the Euler-Cromer method
!Input:
!Xin=X(1), Vin=V(1) -- initial condition at t=0,
!Tfi the final time and steps the number of steps of integration
!(the initial point is counted as the first one)
!Output:
!The arrays T(1..steps), X(1..steps), V(1..steps) which 
!gives x(t_i)=X(i), dx/dt(t_i)=V(i), t_i=T(i) i=1..steps
!where for i=1 we have the initial condition.
!CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine euler_cromer(Xin,Vin,Tfi,steps,T,X,V)
      implicit none
      integer P
      parameter(P=110000)
      real*8 T(P),X(P),V(P) !time t,x(t),v(t)=dx/dt
      real*8 Xin,Vin,Tfi
      integer steps,i
      real*8 h,accel
      
      T(1) = 0.0
      X(1) = Xin
      V(1) = Vin
      h    = Tfi/(steps-1)
      do i = 2,steps
       T(i) = T(i-1)+h
       V(i) = V(i-1)+accel(X(i-1))*h
       X(i) = X(i-1)+V(i)*h  !here is the difference compared to Euler
      enddo

      end

!CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
!Driver routine for integrating equations of motion 
!using the Euler - Verlet method
!Input:
!Xin=X(1), Vin=V(1) -- initial condition at t=0,
!Tfi the final time and steps the number of steps of integration
!(the initial point is counted as the first one)
!Output:
!The arrays T(1..steps), X(1..steps), V(1..steps) which 
!gives x(t_i)=X(i), dx/dt(t_i)=V(i), t_i=T(i) i=1..steps
!where for i=1 we have the initial condition.
!CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine euler_verlet(Xin,Vin,Tfi,steps,T,X,V)
      implicit none
      integer P
      parameter(P=110000)
      real*8 T(P),X(P),V(P) !time t,x(t),v(t)=dx/dt
      real*8 Xin,Vin,Tfi
      integer steps,i
      real*8 h,g_over_l
      parameter(g_over_l=10.0D0)
      real*8 h2,X0,o2h
      real*8 accel

!Initial conditions set here:
      T(1)    = 0.0D0
      X(1)    = Xin
      V(1)    = Vin
      h       = Tfi/(steps-1)   ! time step
      h2      = h*h             ! time step squared
      o2h     = 0.5D0/h           ! h/2
!We have to initialize one more step: X0 corresponds to 'X(0)'
      X0      =     X(1)   - V(1) * h + accel(X(1))  *h2/2.0D0
      T(2)    = h
      X(2)    = 2.0D0*X(1)   - X0       + accel(X(1))  *h2
!Now i starts from 3:      
      do i    = 3,steps
       T(i)   = T(i-1)+h
       X(i)   = 2.0D0*X(i-1) - X(i-2)   + accel(X(i-1))*h2
       V(i-1) = o2h * (X(i)-X(i-2))
      enddo
!Notice that we have one more step for the velocity:
      V(steps)= (X(steps)-X(steps-1))/h 

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
