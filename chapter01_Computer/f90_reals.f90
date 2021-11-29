!C Program to test effect of accuracy or reals calculation:
!C
      program reals
      real*4        x4,  y4,  z4
      real*8        x8,  y8,  z8
      real*16       x16, y16, z16

      x4 = 1.0e+00
      y4 = 0.9999999e+00
      z4 = x4 - y4
      write(*,*) sqrt(z4)

      x8 = 1.0d+00
      y8 = 0.9999999d+00
      z8 = x8 - y8
      write(*,*) sqrt(z8) 

      x16 = 1.0q+00
      y16 = 0.9999999q+00
      z16 = x16 - y16
      write(*,*) sqrt(z16)

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
