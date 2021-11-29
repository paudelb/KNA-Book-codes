!****************************************************************
!set the boundary of a square to given potentials
!****************************************************************
!Use Successive Overrelaxation (SOR) for 
program poisson_eq
 implicit none
 integer,parameter      :: P=51
 logical,dimension(P,P) :: isConductor
 real(8),dimension(P,P) :: V,rho
 real(8)                :: V1,V2,V3,V4,Q,epsilon,omega
 integer                :: L

 L = P
 print *,'Enter V1,V2,V3,V4:'
 read  *, V1,V2,V3,V4
 print *,'Enter 4*PI*Q:'
 read  *, Q
 print *,'Enter epsilon,omega:'
 read  *, epsilon,omega
 print *,'Starting Laplace using SOR:'
 print *,'Grid Size= ',L
 print *,'Boundaries set at V1= ',V1,' V2= ',V2,' V3= ',V3,&
      ' V4= ',V4,' and Q= ',Q
 print *,'Relaxing with accuracy epsilon= ',epsilon
 print *,'omega= ',omega

 call initialize_lattice(V,isConductor,rho,L,V1,V2,V3,V4,Q)
 
 call laplace(V,isConductor,rho,L,epsilon,omega)

 call print_results(V,L)

end program poisson_eq
!****************************************************************
subroutine initialize_lattice(V,isConductor,rho,L,V1,V2,V3,V4,Q)
!****************************************************************
 implicit none
 integer                :: L
 logical,dimension(L,L) :: isConductor
 real(8),dimension(L,L) :: V,rho
 real(8)                :: V1,V2,V3,V4,Q,Area
 integer                :: i,j,L1,L2
!Initialize to 0 and .FALSE.
 V           =  0.0D0
 isConductor = .FALSE.
 rho         =  0.0D0
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
!We set the points with non-zero charge
!A uniform distribution at a center square
 L1 = (L/2)-5
 L2 = (L/2)+5
 if(L1.LT.1) stop 'array rho out of bounds. Small L1'
 if(L2.GT.L) stop 'array rho out of bounds. Large L2'
 Area = (L2-L1+1)*(L2-L1+1)
 do j=L1,L2
  do i=L1,L2
   rho(i,j) = Q/Area !rho is \tilde\rho in notes
  enddo              !so Q is 4*PI*Q
 enddo

!!     Point charge at the center: 
!!     rho(L/2,L/2)=Q

!C C     A uniform distribution at the interior
!C       L1 = 2
!C       L2 = L-1
!C       if(L1.LT.1) stop 'array rho out of bounds. Small L1'
!C       if(L2.GT.L) stop 'array rho out of bounds. Large L2'
!C       Area = (L2-L1+1)*(L2-L1+1)
!C       do j=L1,L2
!C        do i=L1,L2
!C         rho(i,j) = Q/Area
!C        enddo
!C       enddo

end subroutine initialize_lattice
!****************************************************************
subroutine laplace(V,isConductor,rho,L,epsilon,omega)
!****************************************************************
 implicit none
 integer :: L
 logical,dimension(L,L) :: isConductor
 real(8),dimension(L,L) :: V,rho,Vnew
 real(8)                :: epsilon,omega
 integer                :: i,j,icount
 real(8)                :: Res,error

 icount = 0
 Vnew   = V !careful: the loop does not update conducting sites
 do while (.TRUE.)
  error = 0.0D0
  do  j=2,L-1
   do i=2,L-1
!We change the voltage only for non conductors:
    if( .NOT. isConductor(i,j))then
     Res = (V(i-1,j)+V(i+1,j)+V(i,j+1)+V(i,j-1)-4.0D0*V(i,j)+rho(i,j)) !Residual
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
  if( error .LT. epsilon .or. icount .gt. 50000) exit
 enddo
 print *,icount,' err= ',error

end subroutine laplace
!****************************************************************
subroutine  print_results(V,L)
!****************************************************************
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
