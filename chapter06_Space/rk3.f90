!========================================================
!Program to solve a 6 ODE system using Runge-Kutta Method
!Output is written in file rk3.dat
!========================================================
program rk3_solve
 include 'rk3.inc'
 real(8) :: T0,TF,X10,X20,X30,V10,V20,V30
 real(8) :: t,dt,tstep
 integer :: STEPS
 integer :: i
 real(8) :: energy
!Arrays/variables needed by rksuite:
 real(8) TOL,THRES(NEQ),WORK(LENWRK),Y(NEQ),YMAX(NEQ),&
      YP(NEQ),YSTART(NEQ),HSTART
 logical  ERRASS, MESSAGE
 integer  UFLAG
!.. External Subroutines ..
 EXTERNAL          F, SETUP, STAT, UT
!Input:
 print *,'Runge-Kutta Method for 6-ODEs Integration'
 print *,'Enter coupling constants k1,k2,k3,k4:'
 read  *, k1,k2,k3,k4
 print *,'k1= ',k1,' k2= ',k2,' k3= ',k3,' k4= ',k4
 print *,'Enter STEPS,T0,TF,X10,X20,X30,V10,V20,V30:'
 read  *, STEPS,T0,TF,X10,X20,X30,V10,V20,V30
 print *,'No. Steps= ',STEPS
 print *,'Time: Initial T0 =',T0,' Final TF=',TF
 print *,'           X1(T0)=',X10,' X2(T0)=',X20,' X3(T0)=',X30
 print *,'           V1(T0)=',V10,' V2(T0)=',V20,' V3(T0)=',V30
!Initial Conditions
 dt    = (TF-T0)/STEPS
 YSTART(1) = X10
 YSTART(2) = X20
 YSTART(3) = X30
 YSTART(4) = V10
 YSTART(5) = V20
 YSTART(6) = V30
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
 open(unit=11,file='rk3.dat')
 write(11,100) T0,YSTART(1),YSTART(2),YSTART(3),YSTART(4),&
      YSTART(5),YSTART(6),energy(T0,YSTART)
!Calculation:
 do i=1,STEPS
  t = T0 + i*dt
  call UT(F,t,tstep,Y,YP,YMAX,WORK,UFLAG)
  if(UFLAG.GT.2) exit !exit the loop: go after enddo
  write(11,100) tstep,Y(1),Y(2),Y(3),Y(4),Y(5),Y(6),&
       energy(tstep,Y)
 enddo
 close(11)
100 format(8E25.15)
end program rk3_solve
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
