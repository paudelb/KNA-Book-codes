!=================================================================
! from http://gcc.gnu.org/onlinedocs/gfortran/RANDOM_005fSEED.html
! with some improvements and corrections
!
! Routine seeds using system's random_seed() from 
! 1. /dev/urandom, if available, otherwise
! 2. current time and pid
!
! Also provided: save_random_seed(filename):save state in filename
!                cont_random_seed(filename):read   "  from  "  "
!=================================================================
subroutine init_random_seed()
 implicit none
 integer, allocatable :: seed(:)
 integer    :: i, n, un, istat, dt(8), pid, t(2), s
 integer(8) :: count, tms
 logical    :: urandomQ
 call random_seed(size = n)
 allocate(seed(n))
 ! First try if the OS provides a random number generator
 open(newunit=un, file="/dev/urandom", access="stream", &            !newunit is a Fortran 2008 specifier, 
      form="unformatted", action="read", status="old", iostat=istat) !provides automatically an unused unit
 if (istat == 0) then
  read(un) seed
  close(un)
  urandomQ = .TRUE.
 else
  urandomQ = .FALSE.
  ! Fallback to XOR:ing the current time and pid. The PID is
  ! useful in case one launches multiple instances of the same
  ! program in parallel.
  call system_clock(count)
  if (count /= 0) then!transfer is a Fortran 1995 intrinsic, copies bitwise the 8 bytes of count to the 2*4 bytes of t(2)
   t   = transfer(count, t) 
  else !this is in case system_clock returns zero when called for the first time in some systems
   call date_and_time(values=dt)
   tms = (dt(1) - 1970) * 365_8 * 24 * 60 * 60 * 1000 &       !The year
        + dt(2)         *  31_8 * 24 * 60 * 60 * 1000 &       !The month
        + dt(3)                 * 24 * 60 * 60 * 1000 &       !The day of the month
        + dt(5)                      * 60 * 60 * 1000 &       !The hour of the day
        + dt(6)                           * 60 * 1000 &       !The minutes of the hour
        + dt(7)                                * 1000 &       !The seconds of the minute
        + dt(8)                                               !The milliseconds
   t   = transfer(tms, t)
  end if
  s    = ieor(t(1), t(2))
  pid  = getpid() + 1099279 + ISHFT(getpid(),15)! Add a prime and a shifted value of pid
  s    = ieor(s, pid)
  do i=1,n
   seed(i) = s + ISHFTC(1099279,i)  + ISHFTC(37 * i,i+5) + 36269*i*t(MOD(i,2)+1)
  enddo
 endif ! if(istat == 0)
 seed = ABS(seed) !seeds can be negative before this line. OK for random_seed apparently but watch for others...
 if(urandomQ)then
  print '(A,I5,A,50I12)','# init_random_seed: Seeding random_seed from  urandom with n,seed= ',n,' , ',ABS(seed)
 else
  print '(A,I5,A,50I12)','# init_random_seed: Seeding random_seed from time+pid with n,seed= ',n,' , ',ABS(seed)
 endif
 call random_seed(put=seed)
end subroutine init_random_seed
!------------------------------------------------------------------
subroutine save_random_seed(filename)
 implicit none
 character(*)          :: filename
 integer,allocatable   :: seeds(:)
 integer               :: NSEEDS
 call RANDOM_SEED(size = NSEEDS) 
 ALLOCATE(seeds(NSEEDS))
 open(unit=11,file=filename)
 call RANDOM_SEED(GET = seeds)
 write(11,'(500I20)')seeds
 close(11)
 DEALLOCATE(seeds)
 print '(A,A)','# save_random_seed: Saved seeds in   file: ',filename
end subroutine save_random_seed
!------------------------------------------------------------------
subroutine cont_random_seed(filename)
 implicit none
 character(*)          :: filename
 integer,allocatable   :: seeds(:)
 integer               :: NSEEDS,ierr
 call RANDOM_SEED(size = NSEEDS) 
 ALLOCATE(seeds(NSEEDS))
 open(unit=11,file=filename)
 read(11,'(500I20)')seeds
 close(11)
 call RANDOM_SEED(PUT = seeds)
 print '(A,A,500I20)','# cont_random_seed: Read  seeds from file: ',filename,seeds
 DEALLOCATE(seeds)
 return !successful return
 print '(A,A)','# cont_random_seed: Read  seeds from file: ',filename
100 call init_random_seed !on error, initialize again
end subroutine cont_random_seed
!------------------------------------------------------------------
!program testme
!
! call init_random_seed
! do i=1,5
!  call random_number(r)
!  print *,r
! enddo
!
! call random_number(r);print *,r
! call save_random_seed('rrr.dat')
! call random_number(r);print *,r
! call cont_random_seed('rrr.dat')
! call random_number(r);print *,r
!end program testme
!------------------------------------------------------------------

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
