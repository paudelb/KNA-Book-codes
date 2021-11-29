!******************************************************************
!set the boundary of a square to given potential V1
!set the boundary of an inner square to          V2
!Compute: 
! . Electrostatic Potential
! . Total charge on each square Q1, Q2
! . Capacitance: C1=Q1/V1, C2=Q2/V2 (valid physically id V2= -V1, Q2=-Q1)
program laplace_sq
 implicit none
 integer,parameter      :: P=25
 logical,dimension(P,P) :: isConductor
 real(8),dimension(P,P) :: V
 real(8)                :: V1,V2,V3,V4,epsilon
 integer                :: L

 L = P
 print *,'Enter V1,V2:'
 read  *, V1,V2
 print *,'Enter epsilon:'
 read  *, epsilon
 print *,'Starting Laplace:'
 print *,'Grid Size L1= ',L,' Inner conductor L2= ',L/5
 print *,'Boundaries set at V1= ',V1,' V2= ',V2
 print *,'Relaxing with accuracy epsilon= ',epsilon

 call initialize_lattice(V,isConductor,L,V1,V2)
 
 call laplace(V,isConductor,L,epsilon)
 
 call print_results(V,L)

 call compute_capacitance(V,L)

end program laplace_sq
!******************************************************************
subroutine initialize_lattice(V,isConductor,L,V1,V2)
 implicit none
 integer                :: L
 logical,dimension(L,L) :: isConductor
 real(8),dimension(L,L) :: V
 real(8)                :: V1,V2,V3,V4
 integer                :: i,j,L1,L2
!Initialize to 0 and .FALSE.
 V           =  0.0D0
 isConductor = .FALSE.
!We set the outer boundary to be a conductor:
 do i=1,L
  isConductor(1,i) = .TRUE.
  isConductor(i,1) = .TRUE.
  isConductor(L,i) = .TRUE.
  isConductor(i,L) = .TRUE.
  V          (1,i) =  V1
  V          (i,L) =  V1
  V          (L,i) =  V1
  V          (i,1) =  V1
 enddo

!We set the inner boundary to be a conductor:
!To be valid, L should be multiple of 5
 L1 = (L-L/5)/2  +1
 L2 = L1 + (L/5) -1
 do i=L1,L2
  isConductor(L1,i ) = .TRUE.
  isConductor(i ,L1) = .TRUE.
  isConductor(L2,i ) = .TRUE.
  isConductor(i ,L2) = .TRUE.
  V          (L1,i ) =  V2
  V          (i ,L2) =  V2
  V          (L2,i ) =  V2
  V          (i ,L1) =  V2
 enddo


end subroutine initialize_lattice
!******************************************************************
subroutine laplace(V,isConductor,L,epsilon)
 implicit none
 integer :: L
 logical,dimension(L,L) :: isConductor
 real(8),dimension(L,L) :: V
 real(8)                :: epsilon
 integer                :: i,j,icount
 real(8)                :: Vav,error,dV

 icount = 0
 do while (.TRUE.)
  error = 0.0D0
  do  j=2,L-1
   do i=2,L-1
!We change the voltage only for non conductors:
    if( .NOT. isConductor(i,j))then
     Vav = ( V(i-1,j)+V(i+1,j)+V(i,j+1)+V(i,j-1)) * 0.25D0
     dV  = DABS(V(i,j)-Vav)
     if(error .LT. dV ) error = dV !maximum error
     V(i,j) = Vav
    endif
   enddo
  enddo
  icount = icount + 1
  print *,icount,' err= ',error

  if( error .LT. epsilon) return
 enddo

end subroutine laplace
!******************************************************************
subroutine  print_results(V,L)
 implicit none
 integer                :: L
 real(8),dimension(L,L) :: V
 integer                :: i,j

 open(unit=11,file="data")
 do i=1,L
  do j =1,L
   write(11,*)i,j,V(i,j)
  enddo
  write (11,*)'' !print empty line for gnuplot, separate isolines
 enddo

end subroutine print_results
!******************************************************************
!Computes the charge Q1,Q2 on each plate and ratios Q1/V1,Q2/V2
subroutine compute_capacitance(V,L)
 implicit none
 integer :: L
 real(8),dimension(L,L) :: V
 real(8),parameter      :: PI=3.1415926535897932385D0
 integer                :: i,L1,L2
 real(8)                :: Q1,Q2,C1,C2,V1,V2,Ctheor
 real(8)                :: dV,dQ

!We compute charge of outer conductor:
 Q1  = 0.0D0
 C1  = 0.0D0
 do i=1,L
  Q1 = Q1 - (V(2,i  )-V(1,i)) !left   wall
  Q1 = Q1 - (V(i,L-1)-V(i,L)) !right  wall
  Q1 = Q1 - (V(i,2  )-V(i,1)) !bottom wall
  Q1 = Q1 - (V(i,L-1)-V(i,L)) !top    wall
 enddo
 Q1  = Q1/(4.0D0*PI)
 V1  = V(1,1)
 if( V1 .NE. 0.0D0) C1 = Q1/V1

!Now the charge of the inner wall:
!To be valid, L should be multiple of 5
 L1  = (L-L/5)/2  +1
 L2  = L1 + (L/5) -1
 Q2  = 0.0D0
 C2  = 0.0D0
 do i=L1,L2
  Q2 = Q2 - (V(L1-1,i)-V(L1,i)) !left   wall
  Q2 = Q2 - (V(L2+1,i)-V(L2,i)) !right  wall
  Q2 = Q2 - (V(i,L1-1)-V(i,L1)) !bottom wall
  Q2 = Q2 - (V(i,L2+1)-V(i,L2)) !top    wall
 enddo
 Q2  = Q2/(4.0D0*PI)
 V2  = V(L1,L1)
 if(V2 .NE. 0.0D0) C2 = Q2/V2

 Ctheor = 0.5D0*log(5D0)
 print *,'Q1= ',Q1,' Q2= ',Q2
 print *,'V1= ',V1,' V2= ',V2
 print *,'C1= ',C1,' C2= ',C2
 print *,'V= ',DABS(V1),' Q= ',DABS(Q1),' C= ',DABS(C1),' Cth= ',&
      Ctheor
      
end subroutine compute_capacitance
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
