program random_walker
 implicit none
 integer,parameter :: Nwalk = 1000
 integer,parameter :: Nstep = 100000
 integer           :: iwalk,istep,ir
 real(8)           :: x,y
 real(8)           :: drandom
 integer           :: seed
 common /randoms/     seed

 seed = 374676287
 open(unit=20,file='dataR')
 do iwalk = 1,Nwalk
  x = 0.0D0 ; y = 0.0D0
  open(unit=21,file='data')
  do istep=1,Nstep
   ir = INT(drandom()*4)
   select case(ir)
    case(0)
     x = x + 1.0D0
    case(1)
     x = x - 1.0D0
    case(2)
     y = y + 1.0D0
    case(3)
     y = y - 1.0D0
   end select
   write(21,*) x,y 
  enddo !do istep=1,Nstep
  close(21)
  call sleep(2)
  write(20,*) x*x+y*y
  call flush(20) 
 enddo !do iwalk = 1,Nwalk
end program random_walker
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
