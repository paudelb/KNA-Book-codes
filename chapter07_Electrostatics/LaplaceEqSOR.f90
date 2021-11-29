!****************************************************************
program laplace_em
!****************************************************************
 implicit none
!P defines the size of the arrays and is equal to L 
 integer,parameter      :: P=31
 logical,dimension(P,P) :: isConductor
 real(8),dimension(P,P) :: V
!V1 and V2 are the values of the potential on the interior
!conductors. epsilon is the accuracy desired for the convergence
!of the relaxation method in subroutine laplace()
 real(8)                :: V1,V2,epsilon,omega
 integer                :: L

!We ask the user to provide the necessary data: V1,V2 and epsilon
 L = P
 print *,'Enter V1,V2:'
 read  *, V1,V2
 print *,'Enter epsilon,omega:'
 read  *, epsilon,omega
 print *,'Starting Laplace:'
 print *,'Grid Size= ',L
 print *,'Conductors set at V1= ',V1,' V2= ',V2
 print *,'Relaxing with accuracy epsilon= ',epsilon
 print *,'omega= ',omega
!The arrays V and isConductor are initialized
 call initialize_lattice(V,isConductor,L,V1,V2)
!We enter initialized V,isConductor. On exit the
!routine gives the solution V
 call laplace(V,isConductor,L,epsilon,omega)
!We print V in a file.
 call print_results(V,L)

end program laplace_em
!****************************************************************
subroutine initialize_lattice(V,isConductor,L,V1,V2)
!****************************************************************

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
subroutine laplace(V,isConductor,L,epsilon,omega)
!****************************************************************
 implicit none
 integer :: L
 logical,dimension(L,L) :: isConductor
 real(8),dimension(L,L) :: V,Vnew
 real(8)                :: epsilon,omega
 integer                :: i,j,icount
 real(8)                :: Res,error

 icount = 0  
 Vnew   = V !careful: the loop does not update conducting sites
 do while (.TRUE.)
  error = 0.0D0   
  do  j=2,L-1
   do i=2,L-1
!We change V only for non conductors:
    if( .NOT. isConductor(i,j))then
     Res = ( V(i-1,j)+V(i+1,j)+V(i,j+1)+V(i,j-1)-4.0D0*V(i,j))!Residual
     if(error .LT. ABS(Res) ) error = ABS(Res) !maximum error
     Vnew(i,j) = V(i,j)+0.25D0*omega*Res
     if(ISNAN(Vnew(i,j)))then !check if the method diverges
      icount = -9999
      exit
     endif
    endif
   enddo
  enddo
  V = Vnew
  icount = icount + 1
  if( error .LT. epsilon .or. icount .gt. 50000) exit !return to main program
 enddo
 print *,icount,' err= ',error

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
