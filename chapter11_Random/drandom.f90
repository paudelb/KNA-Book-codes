!====================================================
!File: drandom.f90
!Implementation of the Schrage algorithm for a 
!portable modulo generator for 32 bit signed integers
!(from numerical recipes)
!
!returns uniformly distributed pseudorandom numbers
! 0.0 < x < 1.0 (0 and 1 excluded)
!period: 2**31-2 = 2 147 483 646 
!whole period~26-34sec CPU time (Intel Core DUO 2GHz)
!====================================================
real(8) function drandom()
 implicit none
 integer,parameter :: a = 16807      ! a = 7**5
 integer,parameter :: m = 2147483647 ! m = a*q+r   = 2**31-1
 integer,parameter :: q = 127773     ! q = [m/a]
 integer,parameter :: r = 2836       ! r = MOD(m,a)
 real(8),parameter :: f = (1.0D0/m)
 integer           :: p
 integer           :: seed
 real(8)           :: dr
 common /randoms/seed

101 continue
 p       = seed/q              !  = [seed/q]
 seed    = a*(seed- q*p) - r*p !  = a*MOD(seed,q)-r*[seed/q] = MOD(a*seed,m)
 if(seed .lt. 0) seed = seed + m
 dr      = f*seed
!Not necessary with gfortran and ifort on linux but prudent.
!It increases CPU time ~ 10% over the whole period (ifort, 23% gfortran)
 if( dr .le. 0.0D0 .or. dr .ge. 1.0D0) goto 101
 drandom = dr
end function drandom
!!===================================================
!!small test program to see period
!!===================================================
!program testme
! real   (8)           :: x
! integer              :: seed0
! integer(8)           :: i
! integer              :: seed
! common /randoms/seed
! real(8)              :: drandom
!
! seed0 = 582375326
! seed0 = 946352
! seed  =  seed0
! do i=1,2147483647
!  x = drandom()
!  if(x .EQ. 0.0D0)then
!   print *,'SOS: i,x=',i,x
!  endif
!  if(x .LT. 0.0D0)then
!   print *,'SOS: i,x<0=',i,x
!  endif
!  if(x .EQ. 1.0D0)then
!   print *,'SOS: i,x=',i,x
!  endif
!  if(x .GT. 1.0D0)then
!   print *,'SOS: i,x>1=',i,x
!  endif
!  if(seed .eq. seed0)then
!   print *,'PERIOD: i,seed=',i,seed
!  endif
! enddo
!
!end program testme

