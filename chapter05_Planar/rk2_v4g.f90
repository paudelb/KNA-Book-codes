!========================================================
!The acceleration functions f3,f4(t,x1,x2,v1,v2) provided
!by the user
!========================================================
!Free fall in constant gravitational filed with
!ax = -k2 |v|^3 vx    ay = -k2 |v|^3 vy - k1
real(8) function f3(t,x1,x2,v1,v2)
 implicit none
 real(8) :: t,x1,x2,v1,v2
 real(8) ::         k1,k2
 common  /couplings/k1,k2
 f3=-k2*v1*v1*v1*sqrt(v1*v1+v2*v2)  !dx3/dt=dv1/dt=a1
end function f3
!--------------------------------------------------------
real(8) function f4(t,x1,x2,v1,v2)
 implicit none
 real(8) :: t,x1,x2,v1,v2
 real(8) ::         k1,k2
 common /couplings/k1,k2
 f4=-k2*v2*v2*v2*sqrt(v1*v1+v2*v2)-k1   !dx4/dt=dv2/dt=a2
end function f4
!--------------------------------------------------------
real(8) function energy(t,x1,x2,v1,v2)
 implicit none
 real(8) :: t,x1,x2,v1,v2
 real(8) ::         k1,k2
 common  /couplings/k1,k2
 energy = 0.5D0*(v1*v1+v2*v2) + k1*x2
end function energy
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
