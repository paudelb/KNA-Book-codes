!-------------------------------------------------------------------------------------
! Particle's free fall in a well with a two level ground floor
!-------------------------------------------------------------------------------------
program boxgrav
 implicit none
 real(8) :: x0,y0,x1,y1,u0,v0,u1,v1
 real(8) :: t,tf,dt,g
 integer :: Nt,i

 print              *,'# Enter x0,y0,u0,v0,tf,dt'
 read               *,         x0,y0,u0,v0,tf,dt
 print '(A,100F12.4)','#       x0,y0,u0,v0,tf,dt=',x0,y0,u0,v0,tf,dt
!--------------------------------------
 g  = 10.0D0
 Nt = INT(tf/dt)+1
 u1 = u0
 open(unit=11,file='box.dat')
!--------------------------------------
 write(11,*) 0.0D0,x0,y0,u0,v0
 do i=1,Nt-1
  t  = i*dt
  u1 = u0
  v1 = v0 -  g*dt
  x1 = x0 + u1*dt
  y1 = y0 + v1*dt
!-------------------------------------------------------------------------------------
!Here we use conditions without velocity checks:
!Must provide carefully both initial and final conditions to specify which part is:
  if(x1 < -1.0D0                                    ) u1 = -u1  !leftmost  wall
  if(x1 >  1.0D0                                    ) u1 = -u1  !rightmost wall
!Middle vertical wall:
  if(x0 <  0.0D0 .and. y0 < 1.0D0 .and. x1 > 0.0D0  ) u1 = -u1
!Left horizontal wall:
  if(x0 <  0.0D0 .and. y0 < 1.0D0 .and. y1 < 0.0D0  ) v1 = -v1
!Right horizontal wall:
  if(x0 >  0.0D0 .and. y0 > 1.0D0 .and. y1 < 1.0D0  ) v1 = -v1
!-------------------------------------------------------------------------------------
  x0 = x1;y0 = y1 ; u0 = u1 ; v0 = v1
  write(11,*) t,x0,y0,u0,v0
 enddo
 close(11)
end program boxgrav
!-------------------------------------------------------------------------------------
!        These conditions provide also velocity checks:
!Must provide carefully both initial and final conditions to specify which part is:
!  if(x1 < -1.0D0 .and. u0 < 0.0D0                                   ) u1 = -u1  !leftmost  wall
!  if(x1 >  1.0D0 .and. u0 > 0.0D0                                   ) u1 = -u1  !rightmost wall
!!Middle vertical wall:
!  if(x0 <  0.0D0 .and. y0 < 1.0D0 .and. x1 > 0.0D0 .and. u0 > 0.0D0 ) u1 = -u1
!!Left horizontal wall:
!  if(x0 <  0.0D0 .and. y0 < 1.0D0 .and. y1 < 0.0D0 .and. v0 < 0.0D0 ) v1 = -v1
!!Right horizontal wall:
!  if(x0 >  0.0D0 .and. y0 > 1.0D0 .and. y1 < 1.0D0 .and. v0 < 0.0D0 ) v1 = -v1
!-------------------------------------------------------------------------------------
