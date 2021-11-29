!========================================================
!The acceleration functions f3,f4(t,x1,x2,v1,v2) provided
!by the user
!========================================================
!Motion Yukawa potential
!f(r) = k1 e^(-r/k2) (1+r/k2)
!ax= f(r)*x1/r ay= f(r)*x2/r
real(8) function f3(t,x1,x2,v1,v2)
 implicit none
 real(8) :: t,x1,x2,v1,v2
 real(8) ::         k1,k2
 common  /couplings/k1,k2
 real(8) :: r2,r,fr
 r2=x1*x1+x2*x2
 r =sqrt(r2)
 if(r2.gt.0.0D0)then
  fr = k1*exp(-r/k2)/r2*(1.0D0+r/k2)
 else
  fr = 0.0D0
 endif
 
 if(r .gt.0.0D0)then
  f3=fr*x1/r              !dx3/dt=dv1/dt=a1
 else
  f3=0.0D0
 endif
end function f3
!--------------------------------------------------------
real(8) function f4(t,x1,x2,v1,v2)
 implicit none
 real(8) :: t,x1,x2,v1,v2
 real(8) ::         k1,k2
 common  /couplings/k1,k2 
 real(8) :: r2,r,fr
 r2=x1*x1+x2*x2
 r =sqrt(r2)
 if(r2.gt.0.0D0)then
  fr = k1*exp(-r/k2)/r2*(1.0D0+r/k2)
 else
  fr = 0.0D0
 endif

 if(r .gt.0.0D0)then
  f4=fr*x2/r              !dx3/dt=dv1/dt=a1
 else
  f4=0.0D0
 endif
end function f4
!--------------------------------------------------------
real(8) function energy(t,x1,x2,v1,v2)
 implicit none
 real(8) :: t,x1,x2,v1,v2
 real(8) ::         k1,k2
 common  /couplings/k1,k2
 real(8) :: r,Vr
 r=sqrt(x1*x1+x2*x2)
 if( r .gt.0.0D0)then
  Vr = k1*exp(-r/k2)/r
 else
  Vr = 0.0D0
 endif
 energy  = 0.5D0*(v1*v1+v2*v2) + Vr
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
