!====================================================================
!NRRW: non reversal random walks
!--------------------------------------------------------------------
program random_walks
 implicit none
 integer       :: Nwalk,Nstep
 real(8)       :: drandom
 integer       :: ir,dir
 integer(8)    :: iwalk,istep,n
 integer(8)    :: x,y
 real(8)       :: xr,yr
!-------------------------------
 call init(Nwalk,Nstep)
 do iwalk = 1, Nwalk
  x=0;y=0;n=0;dir=INT(drandom()*4)
  do istep=1,Nstep
   ir  = dir+3+INT(drandom()*3)  !choose one out of 3 directions excluding dir
   ir  = MOD(ir,4)
   dir = ir                      !store ir for next step
   select case(ir)
    case(0)                      !careful: directions dir=0,1,2,3 now go counterclockwise:
     x = x + 1                   ! dir    (non reversal dir)   dir+3     ir        MOD(ir,4)
    case(2)                      !----------------------------------------------------------
     x = x - 1                   !  0            2              3        (3,4,5)   (3,0,1)
    case(1)                      !  1            3              4        (4,5,6)   (0,1,2)
     y = y + 1                   !  2            0              5        (5,6,7)   (1,2,3)
    case(3)                      !  3            1              6        (6,7,8)   (2,3,0)
     y = y - 1
    end select
    if(iwalk .le. 50) write(21,'(3I18)')iwalk,x,y
    if( x .eq. 0 .and. y .eq. 0) n = n + 1
  enddo !do istep=1,Nstep
  xr = DBLE(x); yr = DBLE(y)
  write(20,'(I12,G28.17,3I18)')iwalk,xr*xr+yr*yr,x,y,n
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
 open(unit=20,file='dataR')
 open(unit=21,file='data')
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
