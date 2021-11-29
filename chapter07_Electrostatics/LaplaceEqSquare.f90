!******************************************************************
!set the boundary of a square to given potentials
program laplace_sq
 implicit none
 integer,parameter      :: P=31
 logical,dimension(P,P) :: isConductor
 real(8),dimension(P,P) :: V
 real(8)                :: V1,V2,V3,V4,epsilon
 integer                :: L

 L = P
 print *,'Enter V1,V2,V3,V4:'
 read  *, V1,V2,V3,V4
 print *,'Enter epsilon:'
 read  *, epsilon
 print *,'Starting Laplace:'
 print *,'Grid Size= ',L
 print *,'Boundaries set at V1= ',V1,' V2= ',V2,' V3= ',V3,' V4= ',&
      V4
 print *,'Relaxing with accuracy epsilon= ',epsilon


 call initialize_lattice(V,isConductor,L,V1,V2,V3,V4)

 call laplace(V,isConductor,L,epsilon)

 call print_results(V,L)

end program laplace_sq
!******************************************************************
subroutine initialize_lattice(V,isConductor,L,V1,V2,V3,V4)
 implicit none
 integer                :: L
 logical,dimension(L,L) :: isConductor
 real(8),dimension(L,L) :: V
 real(8)                :: V1,V2,V3,V4
 integer                :: i,j
!Initialize to 0 and .FALSE.
 V           =  0.0D0
 isConductor = .FALSE.
!We set the boundary to be a conductor:
 do i=1,L
  isConductor(1,i) = .TRUE.
  isConductor(i,1) = .TRUE.
  isConductor(L,i) = .TRUE.
  isConductor(i,L) = .TRUE.
  V          (1,i) =  V1
  V          (i,L) =  V2
  V          (L,i) =  V3
  V          (i,1) =  V4
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
