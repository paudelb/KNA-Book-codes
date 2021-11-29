!====================================================================
! Simple variation of the rw.f90 program. In order to use it:
! 1. compile:
!> gfortran rw1.f90 drandom.f90 -o rw1
! 2. run and save standard output in a file
!> ./rw1 <Nwalk> <Nstep>   >&  rwalk.dat
! where Nwalk the number of walks and Nstep the length N of the walk.
! 3. Output: 
! The first 15 configurations are explicitly printed in order to 
! visualize them. The format is:
!w <Nwalk>  <x> <y>
! so that the following command puts each configuration in a file 
! rwalk.<Nwalk>:
!> grep ^w rwalk.dat | awk '{print $3,$4 > "rwalk." $2}'
! The other data printed is the final position x,y, the distance 
! squared R^2 and the number of loops n in the format:
!R <Nwalk> <R^2> <x> <y> <n>
! and the average <R^2> can be computed for example by the command:
!> grep ^R rwalk.dat | awk '{print $3}' | ./average
!====================================================================
program random_walks
 implicit none
 integer       :: Nwalk,Nstep
 real(8)       :: drandom
 integer       :: ir
 integer(8)    :: iwalk,istep,n
 integer(8)    :: x,y
 real(8)       :: xr,yr
!-------------------------------
 call init(Nwalk,Nstep)
 do iwalk = 1, Nwalk
  x=0;y=0;n=0
  do istep=1,Nstep
   ir = INT(drandom()*4)
   select case(ir)
    case(0)
     x = x + 1
    case(1)
     x = x - 1
    case(2)
     y = y + 1
    case(3)
     y = y - 1
    end select
    if(iwalk .le. 15) print '(A,3I18)','w ',iwalk,x,y
    if( x .eq. 0 .and. y .eq. 0) n = n + 1
  enddo !do istep=1,Nstep
  xr = DBLE(x); yr = DBLE(y)
  print '(A,I12,G28.17,3I18)','R ',iwalk,xr*xr+yr*yr,x,y,n
 enddo !do iwalk = 1, Nwalk
end program random_walks
!====================================================================
subroutine init(Nwalk,Nstep) 
 character(20) :: arg
 integer       :: seed
 common /randoms/ seed
!Read Nwalk and Nstep from command line arguments:
 if( iargc() .ne. 2)then
  print *,'Usage: rw  <Nwalk> <Nstep>'
  stop
 endif
 call getarg(1,arg); read(arg,*) Nwalk
 call getarg(2,arg); read(arg,*) Nstep
!Seed drandom from /dev/urandom
 open(unit=13, file='/dev/urandom', access='stream', & 
      form='unformatted')
 read (13) seed
 close(13)
end subroutine init
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
