!========================================================
!Program to solve an ODE system using Runge-Kutta Method
!========================================================
program rk2_solve
 implicit none
 integer,parameter       :: NEQ = 4
 integer,parameter       :: P=1010000
 real(8),dimension(P)    :: T
 real(8),dimension(P,NEQ):: X
 real(8),dimension(NEQ)  :: X0
 real(8) :: Ti,Tf
 integer :: Nt, i
 real(8) ::        k1,k2
 common /couplings/k1,k2
 real(8) :: energy
!Input:
 print *,'Runge-Kutta Method for ODE Integration. NEQ= ',NEQ
 print *,'Enter coupling constants:'
 read  *, k1,k2
 print *,'k1= ',k1,' k2= ',k2
 print *,'Enter Nt,Ti,Tf,X0:'
 read  *,       Nt,Ti,TF,X0
 print *,'Nt = ',Nt
 print *,'Time: Initial Ti =',Ti,' Final Tf=',Tf
 print '(A,2000G28.16)','              X0 =',X0
!The Calculation:
 call RK(T,X,Ti,Tf,X0,Nt,P,NEQ)
!Output:
 open(unit=11,file='rkN.dat')
 do i=1,Nt
  write(11,'(2000G28.16)')T(i),X(i,:),&
      energy(T(i),X(i,:))
 enddo
 close(11)
end program rk2_solve
!========================================================
!
!========================================================
subroutine RK(T,X,Ti,Tf,X0,Nt,P,NEQ)
 implicit none
 integer :: Nt,NEQ,P
 real(8),dimension(P)    :: T
 real(8),dimension(P,NEQ):: X
 real(8),dimension(NEQ)  :: X0
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
