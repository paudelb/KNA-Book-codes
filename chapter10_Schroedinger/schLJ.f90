!===========================================================
!file: schLJ.f (Lennard-Jones)
!
!Functions used in RKSTEP routine. Here:
!f1 = psip(x) = psi(x)'
!f2 = psip(x)'= psi(x)''
!
!One has to set:
!  1. V(x), the potential     
!  2. The boundary conditions for psi,psip at x=xmin and x=xmax
!
!===========================================================
!----- potential:
real(8) function V(x)
 implicit none
 real(8) :: x,V0

 V0 = 250.0D0
 V  = 4.0D0*V0*(1.0D0/x**12-1.0D0/x**6)

end function V
!----- boundary conditions:
subroutine boundary(xmin,xmax,psixmin,psipxmin,psixmax,psipxmax)
 implicit none
 real(8) :: xmin,xmax,psixmin,psipxmin,psixmax,psipxmax,V
 real(8) :: energy
 common/params/energy
!----- Initial values at xmin and xmax
 psixmin    =  exp(-xmin*sqrt(DABS(energy-V(xmin))))
 psipxmin   =  sqrt(DABS(energy-V(xmin)))*psixmin
 psixmax    =  exp(-xmax*sqrt(DABS(energy-V(xmax))))
 psipxmax   = -sqrt(DABS(energy-V(xmax)))*psixmax
end subroutine boundary
!===========================================================
!===========================================================
!----- trivial function: derivative of psi      
real(8) function f1(x,psi,psip) 
 real(8) :: x,psi,psip
 f1=psip
end function f1
!===========================================================
!----- the second derivative of wavefunction:
!psip(x)' = psi(x)'' = -(E-V) psi(x)
real(8) function f2(x,psi,psip)
 implicit none
 real(8) :: x,psi,psip,energy,V
 common /params/energy
!----- Schroedinger eq: RHS
 f2 = (V(x)-energy)*psi
end function f2
!===========================================================
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
