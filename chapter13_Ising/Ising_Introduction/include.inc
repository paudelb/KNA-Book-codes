!============== include.inc ==================
 implicit none
 integer,parameter      :: L = 12
 integer,parameter      :: N = L*L
 integer,parameter      :: XNN = 1, YNN = L
 integer,dimension(N)   :: s
 real(8),dimension(0:4) :: prob
 real(8)                :: beta
 common /lattice/          s
 common /parameters/       beta,prob
!function definitions:
 real(8)                :: drandom
 integer                :: seed
 common /randoms/          seed
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
