!     Program to show how adding numbers of different magnitude
!     must be done carefully. Here we sum a series, we have to add
!     small numbers first...
      program rndof
      integer       i
      real          sum
      real*8        sum8

      sum = 0.0
      do i = 1, 10000000, 1
        sum = sum + 1.0 / REAL(i)
      end do
      write (*,*) 'Decreasing order:        ', sum
!     This is slightly more accurate:
      sum = 0.0
      do i = 10000000, 1, -1
        sum = sum + 1.0 / REAL(i)
      end do
      write (*,*) 'Increasing order:        ', sum
!     This is most accurate:
      sum8 = 0.0D0
      do i = 10000000, 1, -1
        sum8 = sum8 + 1.0D0 / DBLE(i)
      end do
      write (*,*) 'Increasing order double: ', sum8

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
