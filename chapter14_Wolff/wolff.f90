subroutine wolff
 use global_data
 implicit none
 integer             :: cseed,nstack,sold,snew,scluster,nn,chk
 integer             :: ncluster
 real(8)             :: r
 integer,allocatable :: stack(:)
!allocate stack memory:
 ALLOCATE(stack(0:N-1),STAT=chk)
 if(chk>0) call locerr('allocation failure for stack in wolff')
!choose a seed for the cluster, put it on the stack and flip it
 call ranlux(r,1)
 cseed    =  INT(N*r)+1
 stack(0) =  cseed
 nstack   =  1          !the stack has 1 member, the seed
 sold     =  s(cseed)    
 snew     = -s(cseed)   !the spin value of the cluster after the flip
 s(cseed) =  snew       !we flip all new members of cluster
 ncluster =  1          !size of cluster=1
!start the loop on spins in the stack:
 do while(nstack > 0)
!pull a site off the stack:
  nstack  = nstack     - 1; scluster = stack(nstack)
!check its four neighbours:
!-------------scluster + XNN:
  nn       =  scluster + XNN; if(nn > N) nn = nn - N
  if(s(nn) == sold)then
   call ranlux(r,1)
   if(r<padd)then
    stack(nstack)=nn; nstack = nstack + 1 
    s(nn)        =snew
    ncluster     =ncluster+1
   endif
  endif
!-------------scluster - XNN:
  nn       =  scluster - XNN; if(nn < 1) nn = nn + N
  if(s(nn) == sold)then
   call ranlux(r,1)
   if(r<padd)then
    stack(nstack)=nn; nstack = nstack + 1 
    s(nn)        =snew
    ncluster     =ncluster+1
   endif
  endif
!-------------scluster + YNN:
  nn       =  scluster + YNN; if(nn > N) nn = nn - N
  if(s(nn) == sold)then
   call ranlux(r,1)
   if(r<padd)then
    stack(nstack)=nn; nstack = nstack + 1 
    s(nn)        =snew
    ncluster     =ncluster+1
   endif
  endif
!-------------scluster - YNN:
  nn       =  scluster - YNN; if(nn < 1) nn = nn + N
  if(s(nn) == sold)then
   call ranlux(r,1)
   if(r<padd)then
    stack(nstack)=nn; nstack = nstack + 1 
    s(nn)        =snew
    ncluster     =ncluster+1
   endif
  endif
 enddo !do while(nstack > 0)
 print '(A,I14)','#clu ',ncluster
!--------------------------------------
 DEALLOCATE(stack)!free memory of stack
!--------------------------------------
end subroutine wolff
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
