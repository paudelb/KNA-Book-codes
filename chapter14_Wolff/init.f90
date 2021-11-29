!============== init.f90    ==================
! start     = 0: cold start
! start     = 1: hot  start
! start     = 2: use old configuration
! algorithm = 0: metropolis updates
! algorithm = 1: wolff      updates
!=============================================
subroutine init
 use global_data
 implicit none
 integer                    :: i,chk
 real(8)                    :: obeta=-1.0D0,r
 integer                    :: OL=-1
 character(1024)            :: buf
 integer,parameter          :: f_in=17 !file unit
 integer                    :: seeds(25)
!----------------------
!Define parameters from options:
 L=-1;beta=-1.0D0;nsweep=-1;start=-1;seed=-1
 ranlux_level=3;algorithm=0!default is metropolis,1 is wolff
 call get_the_options
 if(start.EQ.0 .OR. start.EQ.1)then
  if(L    < 0    )call locerr('L    has not been set.')
  if(seed < 0    )call locerr('seed has not been set.')
  if(beta < 0.0D0)call locerr('beta has not been set.')
!Derived parameters:
  N=L*L;XNN=1;YNN=L
!Allocate memory for the spins:
  ALLOCATE(s(N),STAT=chk)
  if(chk      > 0)call locerr('allocation failure for s(N)')
 endif !if(start.EQ.0 .OR. start.EQ.1)
 if(start     < 0)call locerr('start  has not been set.')
 if(nsweep    < 0)call locerr('nsweep has not been set.')
!----------------------
!initialize probabilities for E_\nu > E_mu
 prob=0.0D0
 do i=2,4,2 !i = dE/2 = (E_nu-E_mu)/2=2,4
  prob(i) = exp(-2.0D0*beta*i)
 enddo
 padd     = 1.0D0 - exp(-2.0D0*beta)
 acceptance = 0.0D0
!--------------------------------------------
!initial configuration: cold(0),hot(1),old(2)
!--------------------------------------------
 select case(start)
!--------------------------------------------
  case(0)!cold:
  call simmessage(6)
   call RLUXGO(ranlux_level,seed,0,0)
   s = 1 !all s(i) = 1
!--------------------------------------------
  case(1)!hot:
  call simmessage(6)
   call RLUXGO(ranlux_level,seed,0,0)
   do i=1,N
    call ranlux(r,1)
    if(r .lt. 0.5D0)then
     s(i) =  1
    else
     s(i) = -1
    endif
   enddo
!--------------------------------------------
  case (2)!old:
   if(beta < 0.0D0)call locerr('beta has not been set.')
   open(f_in,file='conf',status='OLD',ERR=101)
   read(f_in,*)buf !read in a comment line
   read(f_in,'(A4,I5,A4,I5,A6,G28.17,A6,25I16)')&
    buf,OL,buf,OL,buf,obeta,buf,seeds
   if(L  < 0 ) L = OL !if L has not been set, read from file
   if(L /= OL) &  ! /= the same as .NE. (not equal)
    call locerr('Given L different from the one read from conf.')
   N=L*L;XNN=1;YNN=L
!Allocate memory for the spins:
   ALLOCATE(s(N),STAT=chk);
   if(chk      > 0)call locerr('allocation failure for s(N)')
   call simmessage(6)
   print '(A)','# Reading configuration from file conf'
   do i=1,N
    read(f_in,*,END=102) s(i)
    if(s(i) /= 1 .AND. s(i) /= -1)&
     call locerr('wrong value of spin')
   enddo
   close(f_in)
   if(seed < 0) then !initialize from seeds read from file:
    call RLUXIN(seeds)
   else              !option seed sets new seed:
    call RLUXGO(ranlux_level,seed,0,0)
   endif
!--------------------------------------------
  case default
   print *,'init: start= ',start,' not valid. Exiting...'
   stop 1
  end select
!--------------------------------------------
  return
!here we put error messages:
101 call locerr('Configuration file conf not found.')
102 call locerr('File conf ended before reading all spins.')
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
