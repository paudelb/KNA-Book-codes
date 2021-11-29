!========================================================
program anharmonic_elevels
!========================================================
 implicit none
 integer,parameter       :: P     = 1000
 integer,parameter       :: LWORK = 3*P-1
 integer                 :: DIM
 real(8),dimension(P,P)  :: H,X,X4 !Hamiltionian+Position Ops
 real(8),dimension(P)    :: E      !energy eigenvalues
 real(8),dimension(LWORK):: WORK
 real(8)                 :: lambda
 integer                 :: i

 print *,'# Enter Hilbert Space dimension:'
 read  *,DIM
 print *,'# Enter lambda:'
 read  *,lambda
 print *,'# lambda= ',lambda
!Print Message:
 print *,'# ###################################################'
 print *,'# Energy spectrum of anharmonic oscillator'
 print *,'# using matrix methods.'
 print *,'# Hilbert Space Dimension DIM = ',DIM
 print *,'# lambda coupling = ',lambda
 print *,'# ###################################################'
 print *,'# Outpout: DIM lambda E_0 E_1 .... E_{N-1}'
 print *,'# ---------------------------------------------------'

!Calculate X^4 operator:
 call calculate_X4(X,X4,DIM)
!Calculate eigenvalues:
 call calculate_evs(H,X4,E,WORK,lambda,DIM)
 write(6,100)'EV ',DIM,lambda,(E(i),i=1,DIM)
100 FORMAT(A3,I8,20000G25.15)
end program anharmonic_elevels
!========================================================
subroutine calculate_evs(H,X4,E,WORK,lambda,DIM)
!========================================================
 implicit none
 integer,parameter        :: P     = 1000
 integer,parameter        :: LWORK = 3*P-1
 real(8),dimension(P,P)   :: H,X4
 real(8),dimension(P)     :: E
 real(8),dimension(LWORK) :: WORK
 integer                  :: DIM
 real(8)                  :: lambda
 character(1)             :: JOBZ,UPLO
 integer                  :: LDA,INFO,i,j

 call calculate_H(H,X4,lambda,DIM)
 JOBZ='V';UPLO='U'
 call DSYEV(JOBZ,UPLO,DIM,H,P,E,WORK,LWORK,INFO)
 print *,'# ********************** EVEC *******************'
 do j=1,DIM
  write(6,101)'# EVEC ',lambda,(H(i,j), i=1,DIM)
 enddo
 print *,'# ********************** EVEC *******************'
101 FORMAT(A7,F15.3,20000G14.6)
!If INFO is nonzero then we have an error
 if(INFO .ne. 0)then
  print *,'dsyev failed. INFO= ',INFO
  stop
 endif
 
end subroutine calculate_evs
!========================================================
subroutine calculate_H(H,X4,lambda,DIM)
!========================================================
 implicit none
 integer,parameter      :: P = 1000
 real(8),dimension(P,P) :: H,X4
 integer                :: DIM
 real(8)                :: lambda
 integer                :: i,j

 do j=1,DIM
  do i=1,DIM
   H(i,j)=lambda*X4(i,j)
  enddo
  H(j,j) = H(j,j) + DBLE(j) - 0.5D0 !E_n=n+1/2,n=j-1=>E_n=j-1/2
 enddo

 print *,'# ********************** H *******************'
 do j=1,DIM
  write(6,102)'# HH ',(H(i,j), i=1,DIM)
 enddo
 print *,'# ********************** H *******************'

102 FORMAT(A5,20000G20.6)
end subroutine calculate_H
!========================================================
subroutine  calculate_X4(X,X4,DIM)
!========================================================
 implicit none
 integer,parameter     :: P=1000
 real(8),dimension(P,P):: X,X4,X2
 integer               :: DIM
 integer               :: i,j,m,n
 real(8),parameter     :: isqrt2=1.0D0/sqrt(2.0D0)
!Compute the position operator:
 X = 0.0D0
!Compute the nonzero elements
 do i=1,DIM
  n=i-1 !indices 0,...,DIM-1
! The delta_{n,m+1} term, i.e. m=n-1
  m=n-1 !the energy level n -> i=n+1, m-> j=m+1
  j=m+1
  if(j.ge.1  ) X(i,j)=isqrt2*sqrt(DBLE(m+1))
! The delta_{n,m-1} term, i.e. m=n+1
  m=n+1
  j=m+1
  if(j.le.DIM) X(i,j)=isqrt2*sqrt(DBLE(m))
 enddo
!Compute the Hamiltonian operator:
!Start with the X^4 operator:
 X2 = MATMUL(X ,X ) !first X2,then X4:
 X4 = MATMUL(X2,X2)
end subroutine calculate_X4
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
