!==========================================================
!Program that produces N random points (i,j) with
!0<= i,j < 10000. Simple qualitative test of  serial 
!correlations of random number generators on the plane.
!
!compile:
!gfortran correlations2ran.f90 naiveran.f90 drandom.f90 
!==========================================================
program correlations2
 implicit none
 integer,parameter :: L = 10000
 integer           :: i,N
 character(10)     :: arg
 real(8)           :: naiveran,drandom
 integer           :: seed
 common /randoms/     seed
!Read the number of points from first command argument
 if(IARGC() .EQ. 1)then
  call GETARG(1,arg); read(arg,*)N !convert string->integer
 else !default value, if no N given by user:
  N=1000
 endif
 seed = 348325
 do i=1,N
! print *,INT(L * naiveran()),INT(L * naiveran())
  print *,INT(L * drandom ()),INT(L * drandom ())
! if(MOD(i,1000) .eq. 0) then !pause to see progress:
!  call flush( ) !flush data from all units
!  call sleep(2)
! endif
 enddo

end program correlations2
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
