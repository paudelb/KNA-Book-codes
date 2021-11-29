! Very simple arrays. implicit used. no parameter for arrays
program circle_area
 
 dimension R(10)
 
 PI = 3.14159265358979
 R(1) = 2.28
 do i=2,10
  R(i) = R(i-1) + 1.0
 enddo
 
 do i = 1,10
  perimeter = 2*PI*R(i)
  area      = PI*R(i)**2
  print *,i,') R= ',R(i),' perimeter= ',perimeter
  print *,i,') R= ',R(i),' area     = ',area
 enddo

end program circle_area
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
