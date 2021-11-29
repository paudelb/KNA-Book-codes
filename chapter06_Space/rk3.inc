!Basic definitions of variables for the suite rksuite
 implicit none
!NEQ is the number of equations, 6 in 3 dimensions
!METHOD=2 is for RK45.
 INTEGER            NEQ,  LENWRK,       METHOD
 PARAMETER         (NEQ=6,LENWRK=32*NEQ,METHOD=2)
 REAL *8           k1,k2,k3,k4 !force couplings
 COMMON /COUPLINGS/k1,k2,k3,k4
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
