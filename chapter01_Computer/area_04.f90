! We introduce subroutines:
program circle_area

 implicit none

 integer,parameter   :: N=10
 real   ,parameter   :: P=3.141593
 real   ,dimension(N):: R
 real                :: area,perimeter
 integer             :: i

 do i=1,N
  print*,'Enter radius of circle: '
  read *, R(i)
  print*,'i= ',i,' R(i)= ',R(i)
 enddo

 open(UNIT=13,FILE='AREA.DAT')

 do i = 1,N
  call area_of_circle(R(i),perimeter,area)
  write(13,*)i,') R= ',R(i),' area= ',area,' perimeter= ',perimeter
 enddo

 close(13)
 
end program circle_area

subroutine area_of_circle(R,L,A)
 implicit none
 real           :: R,L,A
 real,parameter :: PI = 3.141593 , PI2 = 2.0*PI
 
 L= PI2*R
 A= PI*R*R
 
 return
 
end subroutine area_of_circle


      
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
