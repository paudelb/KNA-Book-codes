!===========================================================
!
! File observables.f90
! Compile: gfortran observables.f90 -o o
! Usage:   ./o <psi.dat>
!
! Read in a file with a wavefunction in the format of psi.dat:
! # E= <energy> ....
! x1  psi(x1)
! x2  psi(x2)
! ............
!
! Outputs expectation values:
! normalization Energy <x> <p> <x^2> <p^2> Dx Dp DxDp
! where Dx = sqrt(<x^2>-<x>^2) Dp = sqrt(<p^2>-<p>^2)
!  DxDp = Dx * Dp
!
!===========================================================
program observables_expectation
 implicit none
 integer,parameter :: P=50000
 integer Nx,i
 real(8) :: xstep(P),psi(P),obs(P)
 real(8) :: xav, pav, x2av, p2av, Dx, Dp, DxDp,energy,h,norm
 real(8) :: integrate
 character(20) ::  psifile,scratch

!the first argument of the command line must be the path
!to the file with the wavefunction. (GNU fortran extension...)
 if( iargc() .ne. 1) stop 'Usage: o  <filename>'
 call getarg(1,psifile)
!If the file does not exist, we go to label 100 (stop):
 open(unit=11,file=psifile,status='OLD',err=100)
 print *,"# reading wavefunction from file:", psifile
!we read the first comment line from the file:
 read(11,*) scratch,scratch,energy
!-------------------------------------------------------
!Input data: psi(x)
 Nx = 1
 do while(.TRUE.)
  if(Nx .ge. P) stop 'Too many points'
  read(11,*,end=101) xstep(Nx),psi(Nx)
  Nx = Nx+1
 enddo !do while(.TRUE.)
101 continue
 Nx = Nx - 1
 if(mod(Nx,2) .eq. 0) Nx = Nx - 1
 h  = (xstep(Nx)-xstep(1))/(Nx-1)
!-------------------------------------------------------
!Calculate:
!---------- norm:
 do i=1,Nx
  obs(i) = psi(i)*psi(i)
 enddo
 norm = integrate(obs,h,Nx)
!---------- <x> :
 do i=1,Nx
  obs(i) = xstep(i)*psi(i)*psi(i)
 enddo
 xav = integrate(obs,h,Nx)/norm
!---------- <p>/i : use quadratic polynomial at boundaries (see Derivatives.nb)
!obs(1) = psi(1)*(psi(2)-psi(1))/h !naive derivative
 obs(1) = psi(1)*(-3.0D0*psi(1)+4.0D0*psi(2)-psi(3))/(2*h)
 do i=2,Nx-1
  obs(i) = psi(i)*(psi(i+1)-psi(i-1))/(2.0D0*h)
 enddo
!obs(Nx) = psi(Nx)*(psi(Nx)-psi(Nx-1))/h !naive
 obs(Nx) = psi(Nx)*&
      (psi(Nx-2)-4.0D0*psi(Nx-1)+3.0D0*psi(Nx))/(2*h)
 pav = -integrate(obs,h,Nx)/norm
!--------- <x^2>
 do i=1,Nx
  obs(i) = xstep(i)*xstep(i)*psi(i)*psi(i)
 enddo
 x2av = integrate(obs,h,Nx)/norm
!-------- <p^2>
!obs(1) = psi(1)*(psi(3)-2.0D0*psi(2)+psi(1))/(h*h) !naive O(h)
 obs(1) = psi(1)*& !better: O(h^2) (See Derivatives.nb)
      (2.0D0*psi(1)-5.0D0*psi(2)+4.0D0*psi(3)-psi(4))/(h*h)
 do i=2,Nx-1
  obs(i) = psi(i)*(psi(i+1)-2.0D0*psi(i)+psi(i-1))/(h*h)
 enddo
!obs(Nx) = psi(Nx)*& !naive: O(h)
!     (psi(Nx)-2.0D0*psi(Nx-1)+psi(Nx-2))/(h*h)
 obs(Nx) = psi(Nx)*&  !better: O(h^2) (see Derivatives.nb)
      (2.0D0*psi(Nx)-5.0D0*psi(Nx-1)+&
      4.0D0*psi(Nx-2)-psi(Nx-3))/(h*h)
 p2av = -integrate(obs,h,Nx)/norm
!-------- Dx
 Dx = sqrt(x2av - xav*xav)
!-------- Dp
 Dp = sqrt(p2av - pav*pav)
!-------- Dx . Dp
 DxDp = Dx*Dp
!print results:
 print *,'# norm E <x> <p>/i <x^2> <p^2> Dx Dp DxDp'
 print '(10G25.17)',norm,energy,xav,pav,x2av,p2av,Dx,Dp,DxDp
 stop !normal execution ends here. Error messages follow
100 stop 'Cannot open file'
end program observables_expectation

!===========================================================
!
!Simpson's rule to integrate psi(x).
!For n intervals of width dx (n even)
!Simpson's rule is:
!int(f(x)dx) = 
! (dx/3)*(f(x_0)+4 f(x_1)+2 f(x_2)+...+4 f(x_{n-1})+f(x_n))
!
!Input:   Discrete values of function psi(Nx)
!         Integration step dx
!Returns: Integral(psi(x)psi(x) dx)
!===========================================================
real(8) function integrate(psi,dx,Nx)
 implicit none
 integer :: Nx
 real(8) :: psi(Nx),dx
 real(8) :: int
 integer i
!----- zeroth order point:
 i    = 1
 int  = psi(i)
!----- odd  order points (i=k+1 is even):
 do i=2,Nx-1,2
  int = int + 4.0D0*psi(i)
 enddo
!----- even order points:
 do i=3,Nx-2,2
  int = int + 2.0D0*psi(i)
 enddo
!----- last point:
 i    = Nx
 int  = int + psi(i)
!----- measure normalization:
 int  = int*dx/3.0D0
!----- final result:
 integrate = int
end function integrate
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
