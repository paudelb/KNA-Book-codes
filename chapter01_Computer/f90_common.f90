! ---------------------------------------
program f90_common
 implicit none
 real :: k1=1.0,k2=1.0,k3=1.0
 common /CONSTANTS/k1,k2

 print *,'main: k1= ',k1,' k2= ',k2,' k3= ',k3
 call s1 !prints k1 and k2 but not k3
 call s2 !changes the value of k2 but not k3
 print *,'main: k1= ',k1,' k2= ',k2,' k3= ',k3

end program f90_common
! ---------------------------------------
subroutine s1()
 implicit none
 real k1,k2,k3
 common /CONSTANTS/k1,k2
      
 print *,'s1: k1= ',k1,' k2= ',k2,' k3= ',k3
end subroutine s1
! ---------------------------------------
subroutine s2()
 implicit none
 real k1,k2,k3
 common /CONSTANTS/k1,k2
      
 k2 = 2.0
 k3 = 2.0
end subroutine s2
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
