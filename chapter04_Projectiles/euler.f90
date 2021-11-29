!=========================================================
!Program to integrate equations of motion for accelerations
!which are functions of x with the method of Euler, 
!Euler-Cromer and Euler-Verlet.
!The user sets initial conditions and the subroutines return
!X(t) and V(t)=dX(t)/dt in arrays T(1..Nt),X(1..Nt),V(1..Nt)
!The user provides number of times Nt and the final
!time Tfi. Initial time is assumed to be t_i=0 and the
!integration step h = Tfi/(Nt-1) 
!The user programs a real function accel(x) which gives the 
!acceleration  dV(t)/dt as function of X.
!NOTE: T(1) = 0 T(Nt) = Tfi
!=========================================================
program diff_eq_euler
 implicit none             
 integer,parameter:: P=110000 ! The size of the arrays
 real,dimension(P):: T,X,V    ! time t,x(t),v(t)=dx/dt
 real     :: Xin,Vin,Tfi      ! initial conditions
 integer  :: Nt,i
!The user provides initial conditions X_0,V_0 final time t_f
!and Nt:
 print *,'Enter X_0,V_0,t_f,Nt (t_i=0):'
 read  *,Xin,Vin,Tfi,Nt
!This check is necessary in order to avoid memory 
!access violations:
 if(Nt .ge. P )then 
  print *,'Nt must be strictly less than P. Nt,P= ',Nt,P
  stop
 endif
!Xin= X(1), Vin=V(1), T(1)=0 and the routine gives evolution in
!T(2..Nt), X(2..Nt), V(2..Nt) which we print in a file
 call euler(Xin,Vin,Tfi,Nt,T,X,V)
 open(unit=20,file="euler.dat")
 do i=1,Nt
!Each line in data file has time, position, velocity:
  write(20,*) T(i),X(i),V(i) 
 enddo
 close(20) !we close the unit to be reused below
!------------------------------------
!We repeat everything for each method
 call euler_cromer(Xin,Vin,Tfi,Nt,T,X,V)
 open(unit=20,file="euler_cromer.dat")
 do i=1,Nt
  write(20,*) T(i),X(i),V(i)
 enddo
 close(20)
!------------------------------------
 call euler_verlet(Xin,Vin,Tfi,Nt,T,X,V)
 open(unit=20,file="euler_verlet.dat")
 do i=1,Nt
  write(20,*) T(i),X(i),V(i)
 enddo
 close(20)
!------------------------------------
end program diff_eq_euler
!=========================================================
!Function which returns the value of acceleration at
!position x used in the integration subroutines
!euler, euler_cromer and euler_verlet
!=========================================================
real function accel(x)
 implicit none
 real x
 accel = -10.0*sin(x)
end function accel
!=========================================================
!Driver routine for integrating equations of motion 
!using the Euler method
!Input:
!Xin=X(1), Vin=V(1) -- initial condition at t=0,
!Tfi the final time and Nt the number of times
!Output:
!The arrays T(1..Nt), X(1..Nt), V(1..Nt) which 
!gives x(t_k)=X(k), dx/dt(t_k)=V(k), t_k=T(k) k=1..Nt
!where for k=1 we have the initial condition.
!=========================================================
subroutine euler(Xin,Vin,Tfi,Nt,T,X,V)
 implicit none
 integer :: Nt
 real,dimension(Nt) :: T,X,V    !time t,x(t),v(t)=dx/dt
 real    :: Xin,Vin,Tfi
 integer :: i
 real    :: h,accel     !**declare the function accel**
!Initial conditions set here:      
 T(1) = 0.0
 X(1) = Xin
 V(1) = Vin
!h is the time step Dt
 h    = Tfi/(Nt-1)
 do i = 2,Nt
  T(i) = T(i-1)+h          ! time advances by Dt=h
  X(i) = X(i-1)+V(i-1)*h   ! advancement and storage of position
  V(i) = V(i-1)+accel(X(i-1))*h !and velocity.
 enddo

end subroutine euler
!=========================================================
!Driver routine for integrating equations of motion 
!using the Euler-Cromer method
!Input:
!Xin=X(1), Vin=V(1) -- initial condition at t=0,
!Tfi the final time and Nt the number of times
!Output:
!The arrays T(1..Nt), X(1..Nt), V(1..Nt) which 
!gives x(t_i)=X(i), dx/dt(t_i)=V(i), t_i=T(i) i=1..Nt
!where for i=1 we have the initial condition.
!=========================================================
subroutine euler_cromer(Xin,Vin,Tfi,Nt,T,X,V)
 implicit none
 integer :: Nt
 real,dimension(Nt):: T,X,V !time t,x(t),v(t)=dx/dt
 real    :: Xin,Vin,Tfi
 integer :: i
 real    :: h,accel
      
 T(1) = 0.0
 X(1) = Xin
 V(1) = Vin
 h    = Tfi/(Nt-1)
 do i = 2,Nt
  T(i) = T(i-1)+h
  V(i) = V(i-1)+accel(X(i-1))*h
  X(i) = X(i-1)+V(i)*h  !here is the difference compared to Euler
 enddo

end subroutine euler_cromer
!=========================================================
!Driver routine for integrating equations of motion 
!using the Euler - Verlet method
!Input:
!Xin=X(1), Vin=V(1) -- initial condition at t=0,
!Tfi the final time and Nt the number of times
!Output:
!The arrays T(1..Nt), X(1..Nt), V(1..Nt) which 
!gives x(t_i)=X(i), dx/dt(t_i)=V(i), t_i=T(i) i=1..Nt
!where for i=1 we have the initial condition.
!=========================================================
subroutine euler_verlet(Xin,Vin,Tfi,Nt,T,X,V)
 implicit none
 integer :: Nt
 real,dimension(Nt):: T,X,V !time t,x(t),v(t)=dx/dt
 real    :: Xin,Vin,Tfi
 integer :: i
 real    :: h,h2,X0,o2h
 real    :: accel
!Initial conditions set here:
 T(1)    = 0.0
 X(1)    = Xin
 V(1)    = Vin
 h       = Tfi/(Nt-1)   ! time step
 h2      = h*h             ! time step squared
 o2h     = 0.5/h           ! h/2
!We have to initialize one more step: X0 corresponds to 'X(0)'
 X0      =     X(1)   - V(1) * h + accel(X(1))  *h2/2.0
 T(2)    = h
 X(2)    = 2.0*X(1)   - X0       + accel(X(1))  *h2
!Now i starts from 3:      
 do i    = 3,Nt
  T(i)   = T(i-1)+h
  X(i)   = 2.0*X(i-1) - X(i-2)   + accel(X(i-1))*h2
  V(i-1) = o2h * (X(i)-X(i-2))
 enddo
!Notice that we have one more step for the velocity:
 V(Nt)= (X(Nt)-X(Nt-1))/h 
end subroutine euler_verlet

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
