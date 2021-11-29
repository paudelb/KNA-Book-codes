!===========================================================
!file: wellInfWell.f
!
!Modification of original well.f file in order to solve the finite
!well problem. File has all necessary functions, compiles alone:
!f77 -O2 wellInfWell.f -o w
!
!The infinite walls of the potential are at |x|=b
!The finite well is for |x|<a
!The well depth is v0
!===========================================================
program even_potential_well
 implicit none
 integer,parameter :: P=10000
 real(8) :: energy,dx,x,epsilon,de,v0,b,a
 common /params/energy,v0,b,a
 integer parity,Nx,iter,i,node
 real(8) :: psi,psip,psinew,psiold
 real(8) :: norm,normalization
 real(8) :: psifinal(-P:P),xstep(-P:P)
!------ Input:
 print *,'Enter energy,parity,a,b,v0,Nx,epsilon:'
 read  *, energy,parity,a,b,v0,Nx,epsilon
 if(Nx  .gt. P) stop 'Nx > P'
 if(parity .gt. 0) then
  parity =  1
 else
  parity = -1
 endif
 print *,'# #######################################'
 print *,'# Estart= ',energy,' parity= ',parity
 print *,'# v0 = ',v0,' b= ',b,' a= ',a
 dx      = b/(Nx-1)
 print *,'# Nx=  ',Nx ,' dx = ',dx,' eps= ',epsilon
 print *,'# #######################################'
!----- Calculate:
 open(unit=11,file='all.dat')
 iter    = 0
 psiold  = 0.0D0 ! calculated values of psi at x=1
 psinew  = 1.0D0 
 de      = 0.1D0*DABS(energy) ! original change in energy
 do while (iter .lt. 10000)
!---------- Initial conditions at x=0
  x      = 0.0D0
  if(parity .eq. 1)then
   psi   = 1.0D0
   psip  = 0.0D0
  else
   psi   = 0.0D0
   psip  = 1.0D0
  endif
  write(11,*) iter,energy, x, psi,psip
! --------- Use Runge-Kutta to forward to x=1
  do i=2,Nx
   x     = (i-2)*dx
   call RKSTEP(x,psi,psip,dx)
   write(11,*) iter,energy,x,psi,psip
  enddo                    ! do i=2,Nx
  psinew = psi
  print *,iter, energy, de,psinew
! --------- Stop if value of psi close to 0
  if(DABS(psinew) .le. epsilon) EXIT
! --------- Change direction of energy search:
  if(psinew*psiold .lt. 0.0D0) de = -0.5D0*de
  energy = energy + de
  psiold = psinew
  iter   = iter + 1
 enddo                     ! do while
 close(11)
!------- We found the solution: calculate it once again and store it
 if(parity .eq. 1)then
  psi    = 1.0D0
  psip   = 0.0D0
  node   = 0  ! count number of nodes of function
 else
  psi    = 0.0D0
  psip   = 1.0D0
  node   = 1
 endif
 x              = 0.0D0
 xstep   (0)    = x
 psifinal(0)    = psi ! array that stores psi(x)
 psiold         = 0.0D0
!------- Use Runge-Kutta to move to x=1
 do i=2,Nx
  x             = (i-2)*dx
  call RKSTEP(x,psi,psip,dx)
  xstep   (i-1) = x
  psifinal(i-1) = psi
! ------ Use parity to compute psi(-x)
  xstep   (1-i) = -x
  psifinal(1-i) = parity*psi
! ------ Determine zeroes of psi(x):
  if (DABS(psi)  .gt. 2.0D0*epsilon)then   !psi should not be zero within epsilon
   if(psi*psiold .lt. 0.0D0) node = node+2 !count zeroes of psi
   psiold = psi
  endif
 enddo                     ! do i=2,Nx
 node = node+1             ! node is now the energy level
!------- Print final solution:
 open(unit=11,file='psi.dat')
 norm = 1.0D0/normalization(psifinal,dx,Nx,P)
 print *,'Final result: E= ',energy,' n= ',node,' parity= ',parity,&
      ' v0= ',v0,' b= ',b,' norm = '      ,norm
 write(11,*)'# E= '         ,energy,' n= ',node,' parity= ',parity,&
      ' v0= ',v0,' b= ',b,' norm = '      ,norm
 do i=-(Nx-1),(Nx-1)
  write(11,*) xstep(i),norm*psifinal(i)
 enddo
 close(11)
end program even_potential_well
!===========================================================
!Functions used in RKSTEP routine. Here:
!f1 = psip(x) = psi(x)'
!f2 = psip(x)'= psi(x)''
!
!All one has to set is V, the potential     
!
!===========================================================
!-------- trivial function: derivative of psi      
real(8) function f1(x,psi,psip) 
 real(8) :: x,psi,psip
 f1=psip
end function f1
!===========================================================
!-------- the second derivative of wavefunction:
!psip(x)' = psi(x)'' = -(E-V) psi(x)
real(8) function f2(x,psi,psip)
 implicit none
 real(8) :: x,psi,psip,energy,V,v0,b,a
 common /params/energy,v0,b,a
!------- potential, set here:
 if( DABS(x) .le. a)then
  V = -v0
 else
  V = 0.0D0
 endif
!------- Schroedinger eq: RHS
 f2 = (V-energy)*psi
end function f2
!===========================================================
!Simpson's rule to integrate psi(x)*psi(x) for proper
!normalization. For n intervals of width dx (n even)
!Simpson's rule is:
!int(f(x)dx) = 
! (dx/3)*(f(x_0)+4 f(x_1)+2 f(x_2)+...+4 f(x_{n-1})+f(x_n))
!
!Input:   Discrete values of function psi(-Nx:Nx)
!         Array psi(-P:P) and its dimension P
!         Integration step dx
!Returns: sqrt( Integral(psi(x)psi(x) dx) )
!===========================================================
real(8) function normalization(psi,dx,Nx,P)
 implicit none
 integer :: P,Nx
!------------- Note: we need P due to geometry of array
 real(8) :: psi(-P:P),dx
!-------------
 real(8) :: int
 integer :: n,k,i
 n    = 2*(Nx-1) ! the Simpson's rule number of intervals
!----- zeroth order point:
 k    = 0           ! the Simpson's point counter: 0<= k <= n
 i    = k-Nx+1   ! mapping k to the index i in psi
 int  = psi(i)*psi(i)
!----- odd  order points:
 do k=1,n-1,2
  i   = k-Nx+1
  int = int + 4.0D0*psi(i)*psi(i)
 enddo
!----- even order points:
 do k=2,n-2,2
  i   = k-Nx+1
  int = int + 2.0D0*psi(i)*psi(i)
 enddo
!----- last point:
 k    = n
 i    = k-Nx+1
 int  = int + psi(i)*psi(i)
!----- measure normalization:
 int  = int*dx/3.0D0
!----- final result:
 normalization = sqrt(int)
end function normalization
!===========================================================
!Subroutine RKSTEP(t,x1,x2,dt)
!Runge-Kutta Integration routine of ODE
!dx1/dt=f1(t,x1,x2) dx2/dt=f2(t,x1,x2)
!User must supply derivative functions:
!real(8) function f1(t,x1,x2)
!real(8) function f2(t,x1,x2) 
!Given initial point (t,x1,x2) the routine advnaces it
!by time dt.
!Input : Inital time t    and function values x1,x2
!Output: Final  time t+dt and function values x1,x2
!Careful!: values of t,x1,x2 are overwritten...
!===========================================================
subroutine RKSTEP(t,x1,x2,dt)
 implicit none
 real(8) :: t,x1,x2,dt
 real(8) :: f1,f2
 real(8) :: k11,k12,k13,k14,k21,k22,k23,k24
 real(8) :: h,h2,h6

 h =dt                          !h =dt, integration step
 h2=0.5D0*h                     !h2=h/2
 h6=h/6.0D0                     !h6=h/6
      
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
