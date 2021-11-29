!=====================================================
!Test performance of random number generators:
! (a) drandom (b) RANLUX (c) random_number
!
!Compile:
!gfortran -O2 performance_ran.f90 drandom.f90 ranlux.F
!=====================================================
!Results (Intel Core DUO, 2GHz, 10**9 random numbers)
!                     CPU    ranlux_level  NARR
!drandom            14.38
!ranlux             46.12    1             1
!ranlux             25.49    1             10000
!ranlux             45.95    2             10000
!ranlux             98.05    3             10000
!ranlux            166.06    4             10000   
!random_number      50.05    -             1
!random_number      32.34    -             10000  
!ifort -fast performance_ran.f90 drandom.f90 ranlux.F
!=====================================================
!Results (Intel Core DUO, 2GHz, 10**9 random numbers)
!                     CPU    ranlux_level  NARR
!drandom             9.93
!ranlux             28.74    1             1
!ranlux             21.82    1             10000
!ranlux             41.00    2             10000
!ranlux             90.24    3             10000
!ranlux            154.67    4             10000   
!random_number      28.71    -             1
!random_number      29.76    -             10000    
!----------------------------------------------------
!Note: with gfortran NARR=1 to NARR>=1000 adds a flat
!      appx. 20 sec overhead independent of ranlux_level
!      or random_number. ifort has no overhead
!====================================================
program performrandoms
 implicit none
 integer,parameter       :: NRANDOMS = 1000000000
 integer,parameter       :: NARR     = 10000
 integer                 :: NCALL
 integer                 :: NSEEDS
 integer,allocatable     :: seeds(:)
 integer                 :: seed0
 integer                 :: seed
 real(8)                 :: r
 real(8),dimension(NARR) :: randoms
 common /randoms/seed
 real(8)                 :: drandom
 integer                 :: icount
 integer                 :: i,generator,ranlux_level
!-------------------------------------------
!select random number generator:
!0=random,1=ranlux scalar,2=ranlux array,3=random_number scalar,4=random_number array
 generator    = 4 
 ranlux_level = 2         !for ranlux only
 seed0        = 582375326 !common seed for all startups.
!-------------------------------------------
 SELECT CASE(generator)
!-------------------------------------------
!test drandom:
  CASE(0)
  seed = seed0
  print *,'START drandom'
  NCALL = NRANDOMS
  do icount = 1,NCALL
   r = drandom()
  enddo
  print *,'icount= ',icount,'NCALL= ',NCALL,' NRANDOMS= ',NRANDOMS
  print *,'END   drandom'
!-------------------------------------------
!test ranlux scalar:
  CASE(1)
  print *,'START ranlux scalar'
  call RLUXGO(ranlux_level,seed0,0,0)
  NCALL = NRANDOMS
  do icount = 1,NCALL
   call ranlux(r,1)
  enddo
  print *,'icount= ',icount,'NCALL= ',NCALL,' NRANDOMS= ',NRANDOMS
  print *,'END   ranlux scalar'
!-------------------------------------------
!test ranlux array:
  CASE(2)
  print *,'START ranlux array'
  call RLUXGO(ranlux_level,seed0,0,0)
  NCALL = NRANDOMS/NARR
  do icount = 1,NCALL
   call ranlux(randoms,NARR)
  enddo
  print '(10000G15.4)',randoms
  print *,'icount= ',icount,'NCALL= ',NCALL,' NRANDOMS= ',NRANDOMS
  print *,'END   ranlux array'
!-------------------------------------------
!test random_number scalar:
  CASE(3)
  print *,'START random_number scalar'
  call RANDOM_SEED(size = NSEEDS) 
  ALLOCATE(seeds(NSEEDS))
  seeds = seed0 + 37 * (/ (i - 1, i = 1, NSEEDS) /)
  call RANDOM_SEED(PUT = seeds)
  NCALL = NRANDOMS
  do icount = 1,NCALL
   call random_number(r)
  enddo
  print *,'icount= ',icount,'NCALL= ',NCALL,' NRANDOMS= ',NRANDOMS
  print *,'END   random_number scalar'
!-------------------------------------------
!test random_number array:
  CASE(4)
  print *,'START random_number array'
  call RANDOM_SEED(size = NSEEDS) 
  ALLOCATE(seeds(NSEEDS))
  seeds = seed0 + 37 * (/ (i - 1, i = 1, NSEEDS) /)
  call RANDOM_SEED(PUT = seeds)
  NCALL = NRANDOMS/NARR
  do icount = 1,NCALL
   call random_number(randoms)
  enddo
  print '(10000G15.4)',randoms
  print *,'icount= ',icount,'NCALL= ',NCALL,' NRANDOMS= ',NRANDOMS
  print *,'END   random_number array'
 END SELECT

end program performrandoms
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
