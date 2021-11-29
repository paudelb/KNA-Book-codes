program test_evs
 implicit none
 integer, parameter :: P     = 100 ! P= LDA
 integer, parameter :: LWORK =3*P-1
 real(8) :: A(P,P),W(P),WORK(LWORK)
 integer :: N  ! DSYEV diagonalizes A(N,N)
 integer :: i,j
 integer :: LDA,INFO
 character(1) :: JOBZ,UPLO
!Define the **symmetric** matrix to be diagonalized
!The subroutine uses the upper triangular part  (UPLO='U')
!therefore the lower triangular part needs not to be defined
 N=4
 A(1,1)=-7.7;
 A(1,2)= 2.1;A(2,2)= 8.3;
 A(1,3)=-3.7;A(2,3)=-16.;A(3,3)=-12.
 A(1,4)= 4.4;A(2,4)= 4.6;A(3,4)=-1.04;A(4,4)=-3.7
!We print the matrix A before calling DSYEV since it is 
!destroyed after the call.
 do i=1,N
  do j=i,N
   print *,'A( ',i,' , ',j,' )=',A(i,j)
  enddo
 enddo
!We ask for eigenvalues AND eigenvectors (JOBZ='V')
 JOBZ='V'; UPLO='U'
 print *,'COMPUTING WITH DSYEV:'
 LDA=P                     !notice that LDA-> P>N !!
 call DSYEV(JOBZ,UPLO,N,A,LDA,W,WORK,LWORK,INFO) 
 print *,'DSYEV: DONE. CHECKING NOW:'
!If INFO is nonzero, then there is an error:
 if(INFO .ne. 0)then
  print *,'DSYEV FAILED. INF0= ',INFO
  stop
 endif
!Print results: W(I) has the eigenvalues:
 print *,'DSYEV: DONE.:'
 print *,'EIGENVALUES OF MATRIX:'
 do i=1,N
  print *,'LAMBDA(',i,')=',W(i)
 enddo
!Eigenvectors are in stored in the columns of A:
 print *,'EIGENVECTORS OF MATRIX'
 do J=1,N
  print *,'EIGENVECTOR ',j,' FOR EIGENVALUE ',W(j)
  do i=1,N
   print *,'V_',j,'(',i,')= ',A(i,j)
  enddo
 enddo
end program test_evs
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
