!==============================================
! File Hermite.f
!
! Compute H_n(x) from recursion formula:
! H_{n+1}(x) = 2 x H_n(x) - 2 n H_{n-1}(x)
!
!==============================================
real(8) function Hermite(n,x)
 implicit none
 real(8) :: x,h0,h1,h2
 integer :: n,i

 if( n .eq. 0 ) then
  Hermite = 1
  return
 endif
 if( n .eq. 1) then
  Hermite = 2.0D0 * x
  return
 endif

 h0  = 1
 h1  = 2.0D0*x
 do i=1,n-1
  h2 = 2.0D0*(x*h1-i*h0)
  h0 = h1
  h1 = h2
 enddo

 Hermite = h2

end function Hermite
!==============================================
!
! energy eigenfunctions of harmonic oscillator:
!
! psi_n(x)    = (1/N_n) exp(-x^2/2) H_n(x)
!   N_n       = sqrt(2^n n! sqrt(pi))
!   N_{n+1}^2 = 2(n+1) N_n^2 
!==============================================
real(8) function hocpsi(n,x)
 implicit none
 integer :: n,i
 real(8) :: x,norm0,norm1,expx2
 real(8) :: Hermite
 real,parameter :: sqrtPI=1.7724538509055159D0
      
 expx2   = exp(-0.5D0*x*x)
 if( n.eq.0)then
  hocpsi = expx2/sqrt(sqrtPI)
  return
 endif
 norm0   = sqrtPI
 do i=0,n-1
  norm1  = 2.0D0*(i+1)*norm0
  norm0  = norm1
 enddo
 hocpsi  = expx2/sqrt(norm1)*Hermite(n,x)
end function hocpsi
! ---------------------------------
! a small main program for testing:
!----------------------------------
!      program test_hermite
!       implicit none
!       real(8) :: Hermite,x,dx,hocpsi
!       integer :: n,m,i
!       n = 9 !H_n(x)
!       m = 1000 !no points
!       x = -8.0d0    ! xmin
!       dx = 16.0d0/m !2.0 is xmax
!       do i = 1,m
!        print *,x,Hermite(n,x),hocpsi(n,x)
!        x = x+dx
!       enddo
!      end program test_hermite
! ---------------------------------
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
