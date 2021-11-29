!****************************************************************
!PROGRAM LAPLACE_EM
!Computes the electrostatic potential around conductors.
!The computation is performed on a square lattice of linear
!dimension L. A relaxation method is used to converge to the
!solution of Laplace equation for the potential.
!DATA STRUCTURE:
!real(8) V(L,L): Value of the potential on the lattice sites
!logical isConductor(L,L): If .TRUE.  site has fixed potential
!                          If .FALSE. site is empty space
!real epsilon: Determines the accuracy of the solution
!The maximum difference of the potential on each site between
!two consecutive sweeps should be less than epsilon.
!PROGRAM STRUCTURE
!main program: 
! . Data Input
! . call subroutines for initialization, computation and
!   printing of results
!subroutine initialize_lattice:
! . Initilization of V(L,L) and isConductor(L,L)
!subroutine laplace:
! . Solves laplace equation using a relaxation method
!subroutine print_results:
! . Prints results for V(L,L) in a file. Uses format compatible
!with splot of gnuplot.
!****************************************************************
program laplace_em
 implicit none
!P defines the size of the arrays and is equal to L 
 integer,parameter      :: P=31
 logical,dimension(P,P) :: isConductor
 real(8),dimension(P,P) :: V
!V1 and V2 are the values of the potential on the interior
!conductors. epsilon is the accuracy desired for the convergence
!of the relaxation method in subroutine laplace()
 real(8)                :: V1,V2,epsilon
 integer                :: L

!We ask the user to provide the necessary data: V1,V2 and epsilon
 L = P
 print *,'Enter V1,V2:'
 read  *, V1,V2
 print *,'Enter epsilon:'
 read  *, epsilon
 print *,'Starting Laplace:'
 print *,'Grid Size= ',L
 print *,'Conductors set at V1= ',V1,' V2= ',V2
 print *,'Relaxing with accuracy epsilon= ',epsilon
!The arrays V and isConductor are initialized
 call initialize_lattice(V,isConductor,L,V1,V2)
!We enter initialized V,isConductor. On exit the
!routine gives the solution V
 call laplace(V,isConductor,L,epsilon)
!We print V in a file.
 call print_results(V,L)

end program laplace_em
!****************************************************************
!subroutine initialize_lattice
!Initializes arrays V(L,L) and isConductor(L,L).
!V(L,L)= 0.0  and isConductor(L,L)= .FALSE. by default
!isConductor(i,j)= .TRUE. on boundary of lattice where V=0
!isConductor(i,j)= .TRUE. on sites with i=  L/3+1, 5<= j <= L-5
!isConductor(i,j)= .TRUE. on sites with i=2*L/3+1, 5<= j <= L-5
!V(i,j) = V1  on all sites with i=  L/3+1, 5<= j <= L-5
!V(i,j) = V2  on all sites with i=2*L/3+1, 5<= j <= L-5
!V(i,j) = 0   on boundary (i=1,L and j=1,L)
!V(i,j) = 0   on interior sites with isConductor(i,j)= .FALSE.
!INPUT: 
!integer L: Linear size of lattice
!real(8)  V1,V2: Values of potential on interior conductors
!OUTPUT:
!real(8)  V(L,L): Array provided by user. Values of potential
!logical isConductor(L,L): If .TRUE.  site has fixed potential
!                          If .FALSE. site is empty space
!****************************************************************
subroutine initialize_lattice(V,isConductor,L,V1,V2)
 implicit none
 integer                :: L
 logical,dimension(L,L) :: isConductor
 real(8),dimension(L,L) :: V
 real(8)                :: V1,V2
 integer                :: i,j

!Initialize to 0 and .FALSE (default values for boundary and
!interior sites).
 V           =  0.0D0
 isConductor = .FALSE.
!We set the boundary to be a conductor: (V=0 by default)
 do i=1,L
  isConductor(1,i) = .TRUE.
  isConductor(i,1) = .TRUE.
  isConductor(L,i) = .TRUE.
  isConductor(i,L) = .TRUE.
 enddo
!We set two conductors at given potential V1 and V2
 do i=5,L-5
  V          (  L/3+1,i) =  V1
  isConductor(  L/3+1,i) = .TRUE.
  V          (2*L/3+1,i) =  V2
  isConductor(2*L/3+1,i) = .TRUE.
 enddo

end subroutine initialize_lattice      
!****************************************************************
!subroutine laplace
!Uses a relaxation method to compute the solution of the Laplace
!equation for the electrostatic potential on a 2 dimensional
!squarelattice of linear size L. 
!At every sweep of the lattice we compute the average Vav of the
!potential at each site (i,j) and we immediately update V(i,j)
!The computation continues until Max |Vav-V(i,j)| < epsilon
!INPUT:
!integer L: Linear size of lattice
!real(8) V(L,L): Value of the potential at each site
!logical isConductor(L,L): If .TRUE.  potential is fixed
!                          If .FALSE. potential is updated
!real(8) epsilon: if Max |Vav-V(i,j)| < epsilon return to
!callingprogram. 
!OUTPUT:
!real(8) V(L,L): The computed solution for the potential
!****************************************************************
subroutine laplace(V,isConductor,L,epsilon)
 implicit none
 integer :: L
 logical,dimension(L,L) :: isConductor
 real(8),dimension(L,L) :: V
 real(8)                :: epsilon
 integer                :: i,j,icount
 real(8)                :: Vav,error,dV

 icount = 0                !counts number of sweeps
 do while (.TRUE.)         !an infinite loop:
  error = 0.0D0            !Exit when error<epsilon
  do  j=2,L-1
   do i=2,L-1
!We change V only for non conductors:
    if( .NOT. isConductor(i,j))then
     Vav = ( V(i-1,j)+V(i+1,j)+V(i,j+1)+V(i,j-1)) * 0.25D0
     dV  = DABS(V(i,j)-Vav)
     if(error .LT. dV ) error = dV !maximum error
     V(i,j) = Vav          ! we immendiately update V(i,j)
    endif
   enddo
  enddo
  icount = icount + 1
  print *,icount,' err= ',error
  if( error .LT. epsilon) return !return to main program
 enddo

end subroutine laplace            
!****************************************************************
!subroutine  print_results
!Prints the array V(L,L) in file "data"
!The format of the output is appropriate for the splot function
!of gnuplot: Each time i changes an empty line is printed.
!INPUT:
!integer L: size of array V
!real(8) V(L,L): array to be printed
!OUTPUT:
!no output
!****************************************************************
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
