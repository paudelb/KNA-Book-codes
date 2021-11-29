program anharmonic_elevels
 implicit none
 integer,parameter :: P     = 1000
 integer,parameter :: LWORK = 3*P-1
 real(8) H (P,P),X(P,P) 
 real(8) X4(P,P)        
 real(8) E(P)           
 real(8) WORK(LWORK)    
 real(8) lambda,lambda0,lambdaf,dlambda
 real(8) hocpsi         !HOC wave functions from Hermite.f90
 integer DIM
 integer i,j
 real(8) xp,xmin,dx,psi
 integer n,m,ip,NP

 print *,'Enter DIM,lambda'
 read  *,DIM,lambda0
 print *,'DIM,lambda= ',DIM,lambda0

 print *,'# ######################################################'
 print *,'# Calculation of energy levels of anharmonic oscillator'
 print *,'# using matrix methods.'
 print *,'# Hilbert Space Dimension = ',DIM
 print *,'# lambda coupling = ',lambda0
 print *,'# ######################################################'
 print *,'# Outpout: lambda E_0 E_1 .... E_{N-1}'
 print *,'# ------------------------------------------------------'


 call calculate_X4(X,X4,DIM)

 call calculate_evs(H,X4,E,WORK,lambda0,DIM)

 write(6,100)'EV ',lambda,(E(i),i=1,DIM)
!We print the eigenfunctions:
 open(unit=11,file='eigenfunctions.dat')
 do i=1,DIM
  n     = i-1
  NP    = 2000             !number of points for function
  xmin  = -8.0D0
  dx    = 16.0D0/(NP-1)
  do ip = 1,NP
   xp   = xmin + (ip-1)*dx
!The eigenvector at level n=0 is |psi_n> = Sum_{m=0}^{DIM-1} H(m+1,n+1) |hocpsi_m>,
!where |hocpsi_n> eigenstate of HOC. 
!Therefor: psi_n(x) = Sum_{m=0}^{DIM-1} H(m+1,n+1) hocpsi_m(x)
!or if i=n+1, j=m+1
!psi_n(x) = Sum_{j=1}^{DIM} H(j,i) hocpsi_{j-1}(x)
   psi  = 0.0D0
   do j =1,DIM
    m   = j-1
    psi = psi + H(j,i)*hocpsi(m,xp)
   enddo !do j=1,DIM
   write(11,*) n,xp,psi
  enddo  !do ip = 1,NP loop over x-values of psi_n(x)
 enddo   !do i=1,DIM
100 FORMAT(A3,1000G25.15)
end program anharmonic_elevels
!===============================================
subroutine calculate_evs(H,X4,E,WORK,lambda,DIM)
!===============================================
 implicit none
 integer,parameter :: P    = 1000
 integer,parameter :: LWORK=3*P-1
 real(8) H(P,P)        
 real(8) X4(P,P)       
 real(8) E(P)          
 real(8) WORK(LWORK)   
 integer DIM
 real(8) lambda

 character *1,JOBZ,UPLO
 integer LDA,INFO,i,j

 call calculate_H(H,X4,lambda,DIM)
 JOBZ='V'
 UPLO='U'
 call dsyev(JOBZ,UPLO,DIM,H,P,E,WORK,LWORK,INFO)
 print *,'# ********************** EVEC *******************'
 do j=1,DIM
  write(6,101)'# EVEC ',lambda,(H(i,j), i=1,DIM)
 enddo
 print *,'# ********************** EVEC *******************'
101 FORMAT(A7,F6.4,1000G14.6)

 if(INFO .ne. 0)then
  print *,'dsyev failed. INFO= ',INFO
  stop
 endif

end subroutine calculate_evs
!===========================================================
subroutine calculate_H(H,X4,lambda,DIM)
 implicit none
 integer,parameter ::  P    =1000
 integer,parameter ::  LWORK=3*P-1
 real(8) H(P,P)        
 real(8) X4(P,P)       
 integer DIM
 real(8) lambda
      
 integer i,j,n,m

 do j=1,DIM
  do i=1,DIM
   H(i,j)=lambda*X4(i,j)
  enddo
  H(j,j) = H(j,j) + DBLE(j) - 0.5D0  !E_n=n+1/2,n=j-1 => E_n=j-1/2
 enddo

 print *,'# ********************** H *******************'
 do j=1,DIM
  write(6,102)'# HH ',(H(i,j), i=1,DIM)
 enddo
 print *,'# ********************** H *******************'
 
102 FORMAT(A5,1000G14.6)
end subroutine calculate_H
!==============================================================
subroutine  calculate_X4(X,X4,DIM)
!==============================================================
 implicit none
 integer,parameter :: P=1000
 real(8) X(P,P),X4(P,P)       
 integer DIM

 integer i,j,m,n,i1,i2,i3
 real(8), parameter :: isqrt2=0.70710678118654752440D0

 do j=1,DIM
  do i=1,DIM
   X (i,j)=0.0D0
   X4(i,j)=0.0D0
  enddo
 enddo


 do i=1,DIM
  n=i-1 
  m=n-1 
  j=m+1
  if(j.ge.1  ) X(i,j)=isqrt2*sqrt(DBLE(m+1))
  m=n+1
  j=m+1
  if(j.le.DIM) X(i,j)=isqrt2*sqrt(DBLE(m))
 enddo

 do j=1,DIM
  do i=1,DIM
   do i1=1,DIM
    do i2=1,DIM
     do i3=1,DIM
      X4(i,j)=X4(i,j)+X(i,i1)*X(i1,i2)*X(i2,i3)*X(i3,j)
     enddo
    enddo
   enddo
  enddo
 enddo

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
