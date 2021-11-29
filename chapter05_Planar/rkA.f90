!========================================================
!Program to solve an ODE system using the
!4th order Runge-Kutta Method
!NEQ: Number of equations
!User supplies two subroutines:
!f(t,x,xdot): with real(8) :: t,x(NEQ),xdot(NEQ) which
!given the time t and current values of functions x(NEQ)
!it returns the values of derivatives: xdot = dx/dt 
!The values of two coupling constants k1,k2 may be used
!in f which are read in the main program and stored in
!common /couplings/k1,k2
!finit(NEQ) : sets the value of NEQ
!
!User Interface: 
!k1,k2: real(8) coupling constants
!Nt,Ti,Tf: Nt-1 integration steps, initial/final time
!X0: real(8),dimension(NEQ): initial conditions
!Output:
!rkA.dat with Nt lines consisting of: T(Nt),X(Nt,NEQ) 
!========================================================
program rk2_solve
 implicit none
 real(8),allocatable :: T (:)
 real(8),allocatable :: X (:,:)
 real(8),allocatable :: X0(:)
 real(8) :: Ti,Tf
 integer :: Nt, NEQ,i
 real(8) ::        k1,k2
 common /couplings/k1,k2
!We need explicit interface, since energy has 
!assumed-shape arrays as arguments.
 INTERFACE
  real(8) function energy(t_intrf,x_intrf)
   implicit none
   real(8) :: t_intrf,x_intrf(:)
  end function energy
 END INTERFACE
!Input:
 print *,'Runge-Kutta Method for ODE Integration.'
!Get the number of equations:
 call finit(NEQ);allocate(X0(NEQ))
 print *,'NEQ= ',NEQ
 print *,'Enter coupling constants:'
 read  *, k1,k2
 print *,'k1= ',k1,' k2= ',k2
 print *,'Enter Nt,Ti,Tf,X0:'
 read  *,       Nt,Ti,TF,X0
 print *,'Nt = ',Nt
 print *,'Time: Initial Ti =',Ti,' Final Tf=',Tf
 print '(A,2000G28.16)','              X0 =',X0
 allocate(T(Nt));allocate(X(Nt,NEQ))
!The Calculation:
 call RK(T,X,Ti,Tf,X0,Nt,NEQ)
!Output:
 open(unit=11,file='rkA.dat')
 do i=1,Nt
  write(11,'(2000G28.16)')T(i),X(i,:),&
      energy(T(i),X(i,:))
 enddo
 close(11)
end program rk2_solve
!========================================================
!Driver of the RKSTEP routine
!========================================================
subroutine RK(T,X,Ti,Tf,X0,Nt,NEQ)
 implicit none
 integer :: Nt,NEQ
 real(8),dimension(Nt)    :: T
 real(8),dimension(Nt,NEQ):: X
 real(8),dimension(NEQ)   :: X0
 real(8) :: Ti ,Tf
 real(8) :: dt         
 real(8) :: TS,XS(NEQ) !values of time and X at given step
 integer :: i
!Initialize variables:
 dt     = (Tf-Ti)/(Nt-1)
 T (1)  = Ti
 X (1,:)= X0
 TS     = Ti
 XS     = X0
!Make RK steps: The arguments of RKSTEP are 
!replaced with the new ones
 do i=2,Nt
  call RKSTEP(TS,XS,dt,NEQ)
  T(i)  = TS
  X(i,:)= XS
 enddo 
end subroutine RK
!========================================================
!Subroutine RKSTEP(t,X,dt)
!Runge-Kutta Integration routine of ODE
!========================================================
subroutine RKSTEP(t,x,dt,NEQ)
 implicit none
 integer :: NEQ
 real(8),dimension(NEQ) :: x
 real(8) :: t,dt,tt
 real(8),dimension(NEQ) :: k1,k2,k3,k4,xx
 real(8) :: h,h2,h6
!We need explicit interface, since f has assumed-shape
!arrays as arguments.
 INTERFACE
  subroutine f(t_intrf,x_intrf,xdot_intrf)
   implicit none
   real(8) :: t_intrf
   real(8),dimension(:):: x_intrf,xdot_intrf
  end subroutine f
 END INTERFACE

 h =dt       !h =dt, integration step
 h2=0.5D0*h  !h2=h/2
 h6=h/6.0D0  !h6=h/6

 call f(t ,x ,k1); xx = x + h2*k1; tt =t+h2
 call f(tt,xx,k2); xx = x + h2*k2; tt =t+h2
 call f(tt,xx,k3); xx = x + h *k3; tt =t+h
 call f(tt,xx,k4)
      
 t =t+h
 x =x +h6*(k1+2.0D0*(k2+k3)+k4)
end subroutine RKSTEP
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
