!============== met.f90     ==================
subroutine met()
 use global_data
 implicit none
 integer :: i,k,acc
 integer :: nn,snn,dE
 real(8) :: r

 acc = 0
 do k=1,N
!pick a random site:
  call ranlux(r,1)
  i = INT(N*r)+1
!snn=sum of neighboring spins:
  snn = 0
  nn=i+XNN;if(nn.gt.N)nn=nn-N;snn = snn + s(nn)
  nn=i-XNN;if(nn.lt.1)nn=nn+N;snn = snn + s(nn)
  nn=i+YNN;if(nn.gt.N)nn=nn-N;snn = snn + s(nn)
  nn=i-YNN;if(nn.lt.1)nn=nn+N;snn = snn + s(nn)
!dE=change in energy/2:
  dE=snn*s(i)
!flip:
  if(dE.le.0)then
   s(i) = -s(i) !accept
   acc  = acc+1
  else 
   call ranlux(r,1)
   if(r < prob(dE)) then
    s(i) = -s(i) !accept
    acc  = acc+1
   endif
  endif
 enddo !do k=1,N: end sweep
 acceptance = acceptance + acc
end subroutine met
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
