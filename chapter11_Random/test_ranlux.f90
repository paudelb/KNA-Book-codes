!=============================================
!File: test_ranlux.f90
!Program to demonstrate the usage of the 
!RANLUX random number generator
!
!Compile with:
!gfortran test_ranlux.f90 ranlux.F
!=============================================
program use_ranlux
 implicit none
 integer,parameter         :: NSEEDS = 25
 integer,dimension(NSEEDS) :: seeds
 integer                   :: seed,ranlux_level
 integer(8)                :: icount
 real(8)                   :: r
 integer,parameter         :: NR=20
 real(8),dimension(NR)     :: randoms
!---------------------------------------
!start from a new seed:
 seed         = 58266273
 ranlux_level = 2
 call RLUXGO(ranlux_level,seed,0,0)
!---------------------------------------
!generate random numbers one by one:
 do icount = 1,10
  call ranlux(r,1)
  print *,r
 enddo
!generate random numbers in an array:
 call ranlux(randoms,NR)
 print '(1000G28.17)',randoms
!---------------------------------------
!save state of ranlux:
 open(unit=11,file='ranlux.seed')
 call RLUXUT(seeds)
 write(11,'(5I20)')seeds
 close(11)
!---------------------------------------
!generate some randoms:
 call ranlux(randoms,NR)
 print '(A,1000G28.17)','#FIRST :',randoms
!---------------------------------------
!read state of ranlux:
 open(unit=11,file='ranlux.seed')
 read(11,*)seeds
 call RLUXIN(seeds)
!---------------------------------------
!generate same randoms!
 call ranlux(randoms,NR)
 print '(A,1000G28.17)','#SECOND:',randoms
end program use_ranlux

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
