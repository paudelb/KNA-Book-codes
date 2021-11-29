program f90_format2
 implicit none
 integer i
 real    x, a(10)
 real*8  x8
 
 i  = 123456
 x  = 2.0  *atan2(1.0,0.0)
 print 100,'x,i= ',i,x
 x8 = 2.0D0*atan2(1.0D0,0.0D0)
 write(6,123) x8,x8,&
      1.0D15*x8,1.0D18*x8
 write(6,4444) x8,x8/2.0,cos(x8)
 write(6,9999)(a(i), i=1,10)
100  FORMAT(A5,I6,F12.7)
123  FORMAT(F18.16,E24.17,G24.17,G24.17)
4444 FORMAT(3F20.16)
9999 FORMAT(200F12.6)
end program f90_format2
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
