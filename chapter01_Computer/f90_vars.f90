program f90_vars
 implicit none

 character(100) :: string

 real(4)    ::   x  !single precision, same as real :: x
 real(8)    ::  x8  !equivalent to: double precision x8
!real(16)   :: x16  !this may not be supported by all compilers.
!Complex Numbers:
 complex(4) :: z    !single precision, same as complex :: z
 complex(8) :: z8   !double precision

!A string: a character array:
 string = 'Hello World!' !string smaller size, leaves blanks
 print *,'A string ::',      string, '::',TRIM(string),'::' !TRIM: trim blanks
 print *,'join them::',      string   //       string ,'::'
 print *,'join them::', TRIM(string)  //  TRIM(string),'::'
!Reals with increasing accuracy: Determine PI=3.14159...
 x   = 4.0  *atan(1.0  )
 x8  = 4.0D0*atan(1.0D0) !Use D for double    precision exponent
!x16 = 4.0Q0*atan(1.0Q0) !Use Q for quadriple precision exponent
 print *,'x4= ',x,' x8= ',x8 !,' x16= ',x16
 print *,'x4: ',range(x ),precision(x ),EPSILON(x ),TINY(x ),HUGE(x )
 print *,'x8: ',range(x8),precision(x8),EPSILON(x8),TINY(x8),HUGE(x8)

!Complex numbers: single precision
 z = (2.0,1.0)*cexp((3.0,-1.0))
 print *,'z= ',z,' Re(z)= ',REAL(z),' Im(z)= ',IMAG(z),&
      ' |z|= ',ABS(z),' z*= ',CONJG(z)
     
!Complex numbers: double precision
 z8 = (2.0D0,1.0D0)*cdexp((3.0D0,-1.0D0))
 print *,'z= ',z8,' Re(z)= ',DBLE(z8),' Im(z)= ',DIMAG(z8),&
      ' |z|= ',CDABS(z8),' z*= ',DCONJG(z8)
 print *,'z4: ',range(z ),precision(z )
 print *,'z8: ',range(z8),precision(z8)
      
end program f90_vars
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
