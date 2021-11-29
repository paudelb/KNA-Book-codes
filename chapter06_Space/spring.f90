!========================================================
!Program to solve a 12 ODE system using Runge-Kutta Method
!Three particles of equal mass m connected with each other
!with a spring. The spring constant of the springs is k and l
!is their equilibrium length.
!k1 = k/m
!k2 = l
!Output is written in file spring.dat
!> gfortran spring.f90 rksuite/rksuite.f -o spring
!> ( echo 1 1 0 0 ; echo 20000 0 20 0 0 0 0 0 3 0 0 2 3 1 1 ) | ./spring
!========================================================
program spring_solve
 include 'spring.inc'
 real(8) :: T0,TF,X10
 real(8) :: x110,x120,v110,v120
 real(8) :: x210,x220,v210,v220
 real(8) :: x310,x320,v310,v320
 real(8) :: t,dt,tstep
 integer :: STEPS
 integer :: i,j
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
 print *,'Enter STEPS,T0,TF,x110,x120,v110,v120,x210,x220,v210,v220,x310,x320,v310,v320:'
 read  *,       STEPS,T0,TF,x110,x120,v110,v120,x210,x220,v210,v220,x310,x320,v310,v320
 print *,'No. Steps= ',STEPS
 print *,'Time: Initial T0 =',T0,' Final TF=',TF
 print *,'x110,x120,v110,v120:',x110,x120,v110,v120
 print *,'x210,x220,v210,v220:',x210,x220,v210,v220
 print *,'x310,x320,v310,v320:',x310,x320,v310,v320
!Initial Conditions
 dt        = (TF-T0)/STEPS
 YSTART(1) = x110;YSTART(5) = x210;YSTART( 9) = x310;
 YSTART(2) = x120;YSTART(6) = x220;YSTART(10) = x320;
 YSTART(3) = v110;YSTART(7) = v210;YSTART(11) = v310;
 YSTART(4) = v120;YSTART(8) = v220;YSTART(12) = v320;
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
 open(unit=11,file='spring.dat')
 write(11,100) T0,(YSTART(j),j=1,NEQ)
!Calculation:
 do i=1,STEPS
  t = T0 + i*dt
  call UT(F,t,tstep,Y,YP,YMAX,WORK,UFLAG)
  if(UFLAG.GT.2) exit !exit the loop: go after enddo
  write(11,100) tstep,(Y(j),j=1,NEQ)
 enddo
 close(11)
100 format(100E25.15)
end program spring_solve
!-------------------------------------------------------------------
!-------------------------------------------------------------------
subroutine F(T,Y,YP)
 include 'spring.inc'
 real(8) :: t
 real(8) :: Y(*),YP(*)
 real(8) :: x11,x12,v11,v12
 real(8) :: x21,x22,v21,v22
 real(8) :: x31,x32,v31,v32
 real(8) :: r12,r13,r23
 real(8) :: l12,l13,l23
 x11 = Y(1);x21 = Y(5);x31 = Y( 9);
 x12 = Y(2);x22 = Y(6);x32 = Y(10);
 v11 = Y(3);v21 = Y(7);v31 = Y(11);
 v12 = Y(4);v22 = Y(8);v32 = Y(12);

 r12 = ((x11-x21)**2+(x12-x22)**2)**(-0.5D0)
 r13 = ((x11-x31)**2+(x12-x32)**2)**(-0.5D0)
 r23 = ((x21-x31)**2+(x22-x32)**2)**(-0.5D0)
 l12 = -(1.0D0-k2*r12)
 l13 = -(1.0D0-k2*r13)
 l23 = -(1.0D0-k2*r23)
!-------------------------------------------
!Particle 1:
 YP( 1) = v11
 YP( 2) = v12
 YP( 3) = k1*((x11-x21)*l12 + (x11-x31)*l13)
 YP( 4) = k1*((x12-x22)*l12 + (x12-x32)*l13)
!-------------------------------------------
!Particle 2:
 YP( 5) = v21
 YP( 6) = v22
 YP( 7) = k1*((x21-x11)*l12 + (x21-x31)*l23)
 YP( 8) = k1*((x22-x12)*l12 + (x22-x32)*l23)
!-------------------------------------------
!Particle 3:
 YP( 9) = v31
 YP(10) = v32
 YP(11) = k1*((x31-x11)*l13 + (x31-x21)*l23)
 YP(12) = k1*((x32-x12)*l13 + (x32-x22)*l23)
end subroutine F
!---------------------------------
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
