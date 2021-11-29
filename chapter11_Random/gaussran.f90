!===================================================
!Function to produce random numbers distributed
!according to the gaussian distribution
!g(x) = 1/(sigma*sqrt(2*pi))*exp(-x**2/(2*sigma**2))
!===================================================
real(8) function gaussran()
 implicit none
 real(8),parameter :: sigma = 1.0D0
 real(8)           :: r,phi
 logical,save      :: new   = .TRUE.
 real(8),save      :: x
 real(8),parameter :: PI2   = 6.28318530717958648D0
 real(8)           :: drandom
 if(new)then
  new      = .FALSE.
  r        =     drandom()
  phi      = PI2*drandom()
  r        = sigma*sqrt(-2.0D0*log(r))
  x        = r*cos(phi)
  gaussran = r*sin(phi)
 else
  new      = .TRUE.
  gaussran = x
 endif
end function gaussran
!===================================================
!program testme
! integer seed
! common /randoms/seed
! real(8) gaussran
! seed = 34324545
! do i=1,10000
!  print *,gaussran()
! enddo
!end program testme
!===================================================
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
