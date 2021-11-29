!=======================================================
! 1-dimensional Diffusion Equation with
! periodic boundary conditions u(0,t)=u(1,t)
! 0<= x <= 1 and 0<= t <= tf
! 
! We set initial condition u(x,t=0) that satisfies 
! the given boundary conditions. 
! Nx is the number of points in spatial lattice:
! x = 0 + (j-1)*dx, j=1,...,Nx and dx = (1-0)/(Nx-1)
! Nt is the number of points in temporal lattice:
! t = 0 + (j-1)*dt, j=1,...,Nt and dt = (tf-0)/(Nt-1)
!
! u(x,0) = \delta_{x,0.5}
!
!=======================================================
program diffusion_1d
 implicit none
 integer,parameter    :: P =100000  ! Max no of points
 real(8),parameter    :: PI=3.1415926535897932D0
 real(8),dimension(P) :: u, d2udx2
 real(8) :: t,x,dx,dt,tf,courant,prob,r2,x0
 integer Nx,Nt,i,j,nnl,nnr
! --- Input:
 print *, '# Enter: Nx, Nt, tf: (P= ',P,' Nx must be < P)'
 read  *, Nx,Nt,tf
 if(Nx .ge. P) stop 'Nx >= P'
 if(Nx .le. 3) stop 'Nx <= 3'
 if(Nt .le. 2) stop 'Nt <= 2'
! --- Initialize:
 dx      = 1.0D0/(Nx-1)
 dt      = tf   /(Nt-1)
 courant = dt/dx**2
 print * ,'# 1d Diffusion Equation on S1: 0<=x<=1, 0<=t<=tf'
 print * ,'# dx= ',dx,' dt= ',dt,' tf= ', tf
 print * ,'# Nx= ',Nx,' Nt= ',Nt
 print * ,'# Courant Number= ',courant
 if(courant .gt. 0.5D0) print *,'# WARNING: courant > 0.5'
 open(unit=11,file='d.dat') ! data file
 open(unit=12,file='e.dat') ! data file
! --- Initial condition at t=0 ------------------------------
 do i= 1, Nx
  x      = (i-1)*dx
  u(i)   = 0.0D0
 enddo
 u(Nx/2) = 1.0D0
 do i= 1,Nx
  x      = (i-1)*dx
  write(11,*) 0.0D0, x, u(i)
 enddo
 write(11,*)' '
! ----------------------------------------------------------
! --- Calculate time evolution:
 do j=2,Nt
  t = (j-1)*dt
! ----- second derivative:
  do i=1,Nx
   nnr = i+1
   if(nnr .gt. Nx) nnr = 1
   nnl = i-1
   if(nnl .lt. 1 ) nnl = Nx
   d2udx2(i) = courant*(u(nnr)-2.0D0*u(i)+u(nnl))
  enddo
! ----- update:
  prob = 0.0D0
  r2   = 0.0D0
  x0   = ((Nx/2)-1)*dx !original position
  do i=1,Nx
   x    =  (i-1)*dx
   u(i) = u(i) + d2udx2(i)
   prob = prob + u(i)
   r2   = r2   + u(i)*(x-x0)*(x-x0)
  enddo
  do i=1,Nx
   x =  (i-1)*dx
   write(11,*) t, x, u(i)
  enddo
  write(11,*)' '
  write(12,*) 'pu ',t, prob,r2,u(Nx/2),u(Nx/4),u(1)
 enddo ! do j=2,Nt

 close(11)
end program diffusion_1d
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
