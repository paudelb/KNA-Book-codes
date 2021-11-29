!========================================================
!Program to solve a 6 ODE system using Runge-Kutta Method
!Output is written in file sr.dat
!Interface to be used with relativistic particles.
!========================================================
program sr_solve
 include 'sr.inc'
 real(8) :: T0,TF,X10,X20,X30,V10,V20,V30
 real(8) :: P10,P20,P30
 real(8) :: P1,P2,P3,V1,V2,V3
 real(8) :: t,dt,tstep
 integer :: STEPS
 integer :: i
 real(8) :: energy
!Arrays/variables needed by rksuite:
 real(8) :: TOL,THRES(NEQ), WORK(LENWRK), Y(NEQ), YMAX(NEQ),&
      YP(NEQ), YSTART(NEQ),HSTART
 logical :: ERRASS, MESSAGE
 integer :: UFLAG
!.. External Subroutines ..
 EXTERNAL          F, SETUP, STAT, UT
!Input:
 print *,'Runge-Kutta Method for 6-ODEs Integration'
 print *,'Special Relativistic Particle:'
 print *,'Enter coupling constants k1,k2,k3,k4:'
 read  *, k1,k2,k3,k4
 print *,'k1= ',k1,' k2= ',k2,' k3= ',k3,' k4= ',k4
 print *,'Enter STEPS,T0,TF,X10,X20,X30,V10,V20,V30:'
 read  *, STEPS,T0,TF,X10,X20,X30,V10,V20,V30
 call momentum(V10,V20,V30,P10,P20,P30)
 print *,'No. Steps= ',STEPS
 print *,'Time: Initial T0 =',T0,' Final TF=',TF
 print *,'           X1(T0)=',X10,' X2(T0)=',X20,' X3(T0)=',X30
 print *,'           V1(T0)=',V10,' V2(T0)=',V20,' V3(T0)=',V30
 print *,'           P1(T0)=',P10,' P2(T0)=',P20,' P3(T0)=',P30

!Initial Conditions
 dt    = (TF-T0)/STEPS
 YSTART(1) = X10
 YSTART(2) = X20
 YSTART(3) = X30
 YSTART(4) = P10
 YSTART(5) = P20
 YSTART(6) = P30
!
!  Set error control parameters.
!
 TOL = 5.0D-6
 do i = 1, NEQ
  THRES(i) = 1.0D-10
 enddo
 MESSAGE = .TRUE.
 ERRASS  = .FALSE.
 HSTART  = 0.0D0
!Initialization:
 call SETUP(NEQ,T0,YSTART,TF,TOL,THRES,METHOD,'Usual Task',&
      ERRASS,HSTART,WORK,LENWRK,MESSAGE)
 open(unit=11,file='sr.dat')
 call velocity(YSTART(4),YSTART(5),YSTART(6),V1,V2,V3)
 write(11,100) T0,YSTART(1),YSTART(2),YSTART(3),&
      V1,V2,V3,&
      energy(T0,YSTART),&
      YSTART(4),YSTART(5),YSTART(6)
!Calculation:
 do i=1,STEPS
  t = T0 + i*dt
  call UT(F,t,tstep,Y,YP,YMAX,WORK,UFLAG)
  if(UFLAG.GT.2) exit
  call velocity(Y(4),Y(5),Y(6),V1,V2,V3)
  write(11,100) tstep,Y(1),Y(2),Y(3),&
       V1,V2,V3,&
       energy(tstep,Y),&
       Y(4),Y(5),Y(6)
 enddo
 close(11)
100 format(11E25.15)
end program sr_solve
!========================================================
!momentum -> velocity  transformation
!========================================================
subroutine velocity(p1,p2,p3,v1,v2,v3)
 implicit none
 real(8) :: v1,v2,v3,p1,p2,p3,v,p,vsq,psq

 psq = p1*p1+p2*p2+p3*p3
      
 v1  = p1/sqrt(1.0D0+psq)
 v2  = p2/sqrt(1.0D0+psq)
 v3  = p3/sqrt(1.0D0+psq)
end subroutine velocity
!========================================================
!velocity -> momentum transformation
!========================================================
subroutine momentum(v1,v2,v3,p1,p2,p3)
 implicit none
 real(8) :: v1,v2,v3,p1,p2,p3,v,p,vsq,psq

 vsq = v1*v1+v2*v2+v3*v3
 if(vsq .ge. 1.0D0 ) stop 'sub momentum: vsq >= 1'
 p1  = v1/sqrt(1.0D0-vsq)
 p2  = v2/sqrt(1.0D0-vsq)
 p3  = v3/sqrt(1.0D0-vsq)
end subroutine momentum
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
