!====================================================================
!Classic walk: probabilities 1/8,1/8,3/8,3/8 to move in each of the
!                            4 directions
!====================================================================
program random_walks
 implicit none
 integer       :: Nwalk,Nstep
 real(8)       :: drandom
 integer       :: ir
 integer(8)    :: iwalk,istep,n
 integer(8)    :: x,y
 real(8)       :: xr,yr,r
!-------------------------------
 call init(Nwalk,Nstep)
 do iwalk = 1, Nwalk
  x=0;y=0;n=0
  do istep=1,Nstep
   r  = drandom()
   ir = 3
   if(r < 0.625D0) ir = 1
   if(r < 0.250D0) ir = 2
   if(r < 0.125D0) ir = 0
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
