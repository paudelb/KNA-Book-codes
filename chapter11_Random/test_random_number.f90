!=============================================
!File: test_random_number.f90
!Program to demonstrate the usage of the 
!random_number Fortran intrinsic random number 
!generator
!Compile with:
!gfortran test_random_number.f90
!=============================================
program use_random_number
 implicit none
 integer               :: NSEEDS
 integer,allocatable   :: seeds(:)
 integer               :: seed
 real(8)               :: r
 integer,parameter     :: NR=20
 real(8),dimension(NR) :: randoms
 integer(8)            :: icount
 integer               :: i
!---------------------------------------
!start from a new seed:
 seed = 47279823
!get number of seeds for generator:
 call RANDOM_SEED(size = NSEEDS) 
 ALLOCATE(seeds(NSEEDS))
!fill in the rest of the seeds:
 seeds = seed + 37 * (/ (i - 1, i = 1, NSEEDS) /)
!initialize the generator from the arrays seeds:
 call RANDOM_SEED(PUT = seeds)
!---------------------------------------
!generate random numbers one by one:
 do icount = 1,10
  call random_number(r)
  print *,r
 enddo
!generate random numbers in an array:
 call random_number(randoms)
 print '(1000G28.17)',randoms
!---------------------------------------
!save state of random_number:
 open(unit=11,file='rannum.seed')
 call RANDOM_SEED(GET = seeds)
 write(11,'(5I20)')seeds
 close(11)
!---------------------------------------
!generate some randoms:
 call random_number(randoms)
 print '(A,1000G28.17)','#FIRST :',randoms
!---------------------------------------
!read state of random_number:
 open(unit=11,file='rannum.seed')
 read(11,*)seeds
 call RANDOM_SEED(PUT = seeds)
!---------------------------------------
!generate same randoms:
 call random_number(randoms)
 print '(A,1000G28.17)','#SECOND:',randoms
end program use_random_number
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
