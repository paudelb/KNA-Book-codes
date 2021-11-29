!============================================================
!File Cylinder3D.f90
!Motion of a free particle in a cylinder with axis the z-axis,
!radius R and 0<z<L
!Use integration with time step dt: x = x + vx*dt 
!                                   y = y + vy*dt 
!                                   z = z + vz*dt
!Use subroutine reflectVonCircle for colisions at r=R
!------------------------------------------------------------
program Cylinder3D
 implicit none
!------------------------------------------------------------
!Declaration of variables
 real(8)  ::  x0,y0,z0,v0x,v0y,v0z,t0,tf,dt,t,x,y,z,vx,vy,vz
 real(8)  ::  L,R,R2,vxy,rxy,r2xy,xc,yc
 integer  ::  i,nr,nz
!------------------------------------------------------------
!Ask user for input:
 print *,'# Enter R, L:'
 read  *,R,L
 print *,'# R= ',R,' L= ',L
 if( R .le. 0.0) stop 'R must be positive.'
 if( L .le. 0.0) stop 'L must be positive.'
 print *,'# Enter x0,y0,z0,v0x,v0y,v0z:'
 read  *,x0,y0,z0,v0x,v0y,v0z
 rxy = DSQRT(x0*x0+y0*y0)
 print *,'# x0 = ',x0 ,' y0 = ',y0 ,' z0=  ',z0, ' rxy= ',rxy
 print *,'# v0x= ',v0x,' v0y= ',v0y,' v0z= ',v0z
 if(rxy .gt. R                   ) stop 'illegal value of rxy > R'
 if(z0  .lt. 0.0D0               ) stop 'illegal value of z0  < 0'
 if(z0  .gt. L                   ) stop 'illegal value of z0  > L'
 if(v0x**2+v0y**2+v0z**2.eq. 0.0 ) stop 'illegal value of v0 = 0.'
 print *,'# Enter t0,tf,dt:'
 read  *,t0,tf,dt
 print *,'# t0= ',t0,' tf= ',tf,' dt= ',dt
!------------------------------------------------------------
!Initialize
 i  = 0
 nr = 0  ;  nz = 0
 t  = t0
 x  = x0 ;  y  = y0 ;  z  = z0
 vx = v0x; vy  = v0y;  vz = v0z
 R2 = R*R
 xc = 0.0D0 !center of circle which is the projection of the
 yc = 0.0D0 !cylinder on the xy plane
 open(unit=11,file='Cylinder3D.dat')
!------------------------------------------------------------
!Compute:
 do while(t .le. tf)
  write(11,100)t,x,y,z,vx,vy,vz
  i = i  + 1
  t = t0 + i *dt
  x = x  + vx*dt
  y = y  + vy*dt
  z = z  + vz*dt
  if(z .lt. 0.0 .or. z .gt. L) then
   vz = -vz           ! reflection on cylinder caps
   nz =  nz + 1
  endif
  r2xy = x*x+y*y
  if( r2xy .gt. R2)then
   call reflectVonCircle(vx,vy,x,y,xc,yc,R)
   nr  = nr + 1
  endif
 enddo
 close(11)
 print *,'# Number of collisions:'
 print *,'# nr= ',nr,' nz= ',nz
 
100 FORMAT(100G28.16)
end program Cylinder3D
!------------------------------------------------------------
!============================================================
!------------------------------------------------------------
subroutine reflectVonCircle(vx,vy,x,y,xc,yc,R)
 implicit none
 real(8)  :: vx,vy,x,y,xc,yc,R
 real(8)  :: theta,cth,sth,vr,vth
 
 theta = atan2(y-yc,x-xc)
 cth   = cos(theta)
 sth   = sin(theta)
 
 vr    =  vx*cth + vy *sth
 vth   = -vx*sth + vy *cth
 
 vx    = -vr*cth - vth*sth !reflect vr -> -vr
 vy    = -vr*sth + vth*cth
 
 x     =  xc     + R*cth   !put x,y on the circle
 y     =  yc     + R*sth
end subroutine reflectVonCircle
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
