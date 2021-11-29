!===========================================================
!Discrete Logistic Map:
!Entropy calculation from S=-sum_i p_i ln p_i
!Calculation for r in [rmin,rmax] with RSTEPS steps
! RSTEPS: values or r studied: r=rmin+(rmax-rmin)/RSTEPS
! NHIST : number of histogram bins for calculation of p_i
! NSTEPS: number of values of x in the histograms
! NTRANS: number of discarted iteration in order to discart
!         transient behaviour
! xstart: value of initial x0 for every r
!===========================================================
program logistic_map
 implicit none
 real(8),parameter :: rmin   = 2.5D0
 real(8),parameter :: rmax   = 4.0D0
 real(8),parameter :: xstart = 0.2D0
 integer,parameter :: RSTEPS = 1000
 integer,parameter :: NHIST  = 10000
 integer,parameter :: NTRANS = 2000
 integer,parameter :: NSTEPS = 5000000
 real(8),parameter :: xmin=0.0D0,xmax=1.0D0
 integer :: i,ir,isum,n
 real(8) :: r,x0,x1,sum,dr,dx
 real(8) :: p(NHIST),S

 open(unit=33,file='entropy.dat')
 p  = 0.0D0
 dr = (rmax-rmin)/(RSTEPS-1)
 dx = (xmax-xmin)/(NHIST -1)
 do ir=0,RSTEPS-1
  r = rmin+ir*dr
  x0= xstart
  do i=1,NTRANS
   x1  = r * x0  * (1.0D0-x0 )
   x0  = x1
  enddo
!make histogram:
  n=INT(x0/dx)+1;p(n)=p(n)+1.0D0
  do i=2,NSTEPS
   x1  = r * x0  * (1.0D0-x0 )
   n   = INT(x1/dx)+1
   p(n)=p(n)+1.0D0
   x0  = x1
  enddo
!p(k) is now histogram of x-values.
!Normalize so that sum_k p(k)*dx=1
!to get probability distribution:
  p    = p/NSTEPS/dx
!sum all non zero terms: p(n)*log(p(n))*dx
  S    = -SUM(p*log(p),MASK=p.gt.0.0D0)*dx
  write(33,*)r,S
 enddo !do ir=0,RSTEPS-1
 close(33)
!print the last probability distribution:
 open(unit=34,file='entropy_hist.dat')
 do n=1,NHIST
  x0 = xmin +(n-1)*dx + 0.5D0*dx
  write(34,*) r,x0,p(n)
 enddo
 close(34)
end program logistic_map


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
