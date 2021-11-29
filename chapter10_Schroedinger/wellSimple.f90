!===========================================================
!file: well.f
!
!Computation of energy eigenvalues and eigenfunctions
!of a particle in an infinite well with V(-x)=V(x)
!
!Input:  energy: initial guess for energy
!        parity: desired parity of solution (+/- 1)
!        Nx-1  : Number of RK4 steps from x=0 to x=1
!Output: energy: energy eigenvalue
!        psi.dat: final psi(x)
!        all.dat: all psi(x) for trial energies
!===========================================================
program even_potential_well
 implicit none
 integer,parameter :: P=10000
 real(8) :: energy,dx,x,epsilon,de
 common /params/energy
 integer :: parity,Nx,iter,i
 real(8) :: psi,psip,psinew,psiold
 real(8) :: psifinal(-P:P),xstep(-P:P)
!------ Input:
 print *,'Enter energy,parity,Nx:'
 read  *, energy,parity,Nx
 if(Nx  .gt. P) stop 'Nx > P'
 if(parity .gt. 0) then
  parity =  1
 else
  parity = -1
 endif
 print *,'# #######################################'
 print *,'# Estart= ',energy,' parity= ',parity
 dx      = 1.0D0/(Nx-1)
 epsilon = 1.0D-6
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
 else
  psi    = 0.0D0
  psip   = 1.0D0
 endif
 x              = 0.0D0
 xstep   (0)    = x
 psifinal(0)    = psi ! array that stores psi(x)
!------- Use Runge-Kutta to move to x=1
 do i=2,Nx
  x             = (i-2)*dx
  call RKSTEP(x,psi,psip,dx)
  xstep   (i-1) = x
  psifinal(i-1) = psi
! ------ Use parity to compute psi(-x)
  xstep   (1-i) = -x
  psifinal(1-i) = parity*psi
 enddo                     ! do i=2,Nx
!------- Print final solution:
 open(unit=11,file='psi.dat')
 print *,'Final result: E= ',energy,' parity= ',parity
 write(11,*)'# E= '         ,energy,' parity= ',parity
 do i=-(Nx-1),(Nx-1)
  write(11,*) xstep(i),psifinal(i)
 enddo
 close(11)
end program even_potential_well
!===========================================================
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
