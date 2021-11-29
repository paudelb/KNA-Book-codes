!========================================================
program doublewell_elevels
!========================================================
! H      : Hamiltonian operator H0+(lambda/4)*X^4
! H0     : Hamiltonian H0=1/2 P^2-1/2 X^2 
! X,X2,X4: Position operator and its powers
! iP     : i P operator
! P2     : P^2 = -(iP)(iP) operator
! E      : Energy eigenvalues
! WORK   : Workspace for lapack routine DSYEV
!========================================================
 implicit none
 integer,parameter       :: P=1000
 integer,parameter       :: LWORK=3*P-1
 real(8),dimension(P,P)  :: H,H0,X,X4,X2,iP,P2
 real(8),dimension(P)    :: E
 real(8),dimension(LWORK):: WORK
 real(8)                 :: lambda,lambda0,lambdaf,dlambda
 integer                 :: DIM0,DIMF,dDIM,DIM
 integer                 :: i

!Minimum and maximum values of Hilbert space dimensions:
 print *,'Enter Hilbert Space dimensions (DIM0,DIMF,DDIM):'
 read  *,DIM0,DIMF,DDIM
!Minimum and maximum values of lambda (step dlambda):
 print *,'Enter lambda0,lambdaf,dlambda:'
 read  *,lambda0,lambdaf,dlambda
 print *,'lambda0= ',lambda0
!Print Message:
 print *,'# ###################################################'
 print *,'# Energy levels of double well potential'
 print *,'# using matrix methods.'
 print *,'# Hilbert Space Dimensions = ',DIM0,' - ',DIMF,&
      ' step= ',dDIM
 print *,'# lambda coupling = ',lambda0,' - ',lambdaf,&
      ' step= ',dlambda
 print *,'# ###################################################'
 print *,'# Outpout: DIM lambda E_0 E_1 .... E_{N-1}'
 print *,'# ---------------------------------------------------'

 do DIM=DIM0,DIMF,dDIM

  call calculate_operators(X,X2,X4,iP,P2,H0,DIM)

  lambda = lambda0
  do while (lambda .le. lambdaf )
   call calculate_evs(H,H0,X4,E,WORK,lambda,DIM)
   write(6,100)'EV ',DIM,lambda,(E(i),i=1,DIM)
   lambda = lambda+dlambda
  enddo
 enddo
100 FORMAT(A3,I5,1000G25.15)
end program doublewell_elevels
!========================================================
subroutine calculate_evs(H,H0,X4,E,WORK,lambda,DIM)
!========================================================
 implicit none
 integer,parameter        :: P=1000
 integer,parameter        :: LWORK=3*P-1
 real(8),dimension(P,P)   :: H,H0,X4
 real(8),dimension(P)     :: E
 real(8),dimension(LWORK) :: WORK
 integer                  :: DIM
 real(8)                  :: lambda
 character(1)             :: JOBZ,UPLO
 integer                  :: LDA,INFO,i,j

 call calculate_H(H,H0,X4,lambda,DIM)
 JOBZ='V';UPLO='U'
 call DSYEV(JOBZ,UPLO,DIM,H,P,E,WORK,LWORK,INFO)
 print *,'# ********************** EVEC *******************'
 do j=1,DIM
  write(6,101)'# EVEC ',DIM,lambda,(H(i,j), i=1,DIM)
 enddo
 print *,'# ********************** EVEC *******************'
101 FORMAT(A7,I5,F8.4,1000G14.6)

 if(INFO .ne. 0)then
  print *,'dsyev failed. INFO= ',INFO
  stop
 endif

end subroutine calculate_evs
!========================================================
subroutine calculate_H(H,H0,X4,lambda,DIM)
!========================================================
 implicit none
 integer,parameter      :: P=1000
 real(8),dimension(P,P) :: H,H0,X4
 integer                :: DIM
 real(8)                :: lambda
 integer                :: i,j

 do j=1,DIM
  do i=1,DIM
   H(i,j)=H0(i,j)+0.25D0*lambda*X4(i,j)
  enddo
 enddo

 print *,'# ********************** H *******************'
 do j=1,DIM
  write(6,102)'# HH ',(H(i,j), i=1,DIM)
 enddo
 print *,'# ********************** H *******************'

102 FORMAT(A5,1000G14.6)
end subroutine calculate_H
!========================================================
subroutine  calculate_operators(X,X2,X4,iP,P2,H0,DIM)
!========================================================
 implicit none
 integer,parameter      :: P=1000
 real(8),dimension(P,P) :: X,X4,X2,iP,P2,H0
 integer                :: DIM
 integer                :: i,j,m,n
 real(8),parameter      :: isqrt2=1.0D0/sqrt(2.0D0)

 X =0.0D0;X2=0.0D0;X4=0.0D0
 iP=0.0D0;P2=0.0D0

 do i=1,DIM
  n=i-1 !indices 0,...,DIM-1
! The delta_{n,m+1} term, i.e. m=n-1
  m=n-1 !energy level: n -> i=n+1, m-> j=m+1
  j=m+1
  if(j.ge.1) X (i,j) =  isqrt2*sqrt(DBLE(m+1))
  if(j.ge.1) iP(i,j) = -isqrt2*sqrt(DBLE(m+1))
! The delta_{n,m-1} term, i.e. m=n+1
  m=n+1
  j=m+1
  if(j.le.DIM) X (i,j) =  isqrt2*sqrt(DBLE(m))
  if(j.le.DIM) iP(i,j) =  isqrt2*sqrt(DBLE(m))
 enddo !do i=1,DIM

 X2 =  MATMUL( X, X)
 P2 = -MATMUL(iP,iP)
 X4 =  MATMUL(X2,X2)

!The Hamiltionian:
 H0 =  0.5D0*(P2-X2)

end subroutine calculate_operators
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
