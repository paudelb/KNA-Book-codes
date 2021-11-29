!============== measure.f90 ==================
subroutine measure()
 include 'include.inc'
 integer :: E,M
 print *, E(),M()
end subroutine measure
!=====================
integer function E()
 include 'include.inc'
 integer en,sum,i,nn
 en = 0
 do i=1,N
!Sum of neighboring spins: only forward nn necessary in the sum
  sum = 0
  nn=i+XNN;if(nn.gt.N)nn=nn-N;sum = sum + s(nn)
  nn=i+YNN;if(nn.gt.N)nn=nn-N;sum = sum + s(nn)
  en=en+sum*s(i)
 enddo
 e = -en
end function E
!=====================
integer function M()
 include 'include.inc'
 M=SUM(s)
end function M
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
