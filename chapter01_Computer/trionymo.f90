! =============================================================
! Program to compute roots of a 2nd order polynomial
! Tasks: Input from user,logical statements,use of functions,stop
!        Accuracy in floating point arithmetic e.g. IF(x.eq.0.0)
!  
! Tests: a,b,c= 1  2  3 D=   -8
!        a,b,c= 1 -8 16 D=    0  x1=   4
!        a,b,c= 1 -1 -2 D=    9. x1=   2. x2=  -1.
!        a,b,c= 2.3 -2.99 -16.422 x1=   3.4 x2=  -2.1
! But:   6.8(x-4.3)**2 = 6.8 x**2 -58.48*x+125.732
!        a,b,c= 6.8 -58.48 125.73199 
!        D= 0.000204147349  x1=   4.30105066 x2=   4.29894924
!        a,b,c= 6.8 -58.48 125.732, D=   -0.000210891725 < 0!!
! =============================================================
program trionymo
 implicit none
 real :: a,b,c,D
 real :: x1,x2
 real :: Discriminant

 print*,'Enter a,b,c:'
 read *,a,b,c

! Test if we have a well defined polynomial of 2nd degree:
 if( a .eq. 0.0) stop 'trionymo: a=0'

! Compute the discriminant (= diakrinousa)
 D = Discriminant(a,b,c)
 print *, 'Discriminant: D=  ',D


! Compute the roots in each case: D>0, D=0, D<0 (no roots)
 if(D .gt. 0.0 )then
  call roots(a,b,c,x1,x2)
  print *,'Roots:        x1= ',x1,' x2= ',x2
 else if (D .eq. 0.0) then
  call roots(a,b,c,x1,x2)
  print *,'Double Root:  x1= ',x1
 else
  print *,'No real roots'
 endif

end program trionymo
! =============================================================
! This is the function that computes the discriminant (diakrinousa)
! A function returns a value. This value is assigned with the
! statement:
! Discriminant = <value>  
! i.e. we simply assign anywhere in the program a variable with the
! name  of the function.
! =============================================================
real function Discriminant(a,b,c)
 implicit none
 real :: a,b,c

 Discriminant = b**2 - 4.0 * a * c

end function Discriminant
! =============================================================
! The subroutine that computes the roots.
! =============================================================
subroutine roots(a,b,c,x1,x2)
 implicit none
 real :: a,b,c
 real :: x1,x2
 real :: D, Discriminant

 if(a .eq. 0.0) stop 'roots: a=0'

 D = Discriminant(a,b,c)
 if(D.ge.0.0)then
  D = sqrt(D)
 else
  print *,'roots: Sorry, cannot compute roots, D<0=',D
  stop
 endif

 x1 = (-b + D)/(2.0*a)
 x2 = (-b - D)/(2.0*a)
 
end subroutine roots
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
