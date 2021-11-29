!============== options.f90 ==================
subroutine get_the_options
 use global_data
 use getopt_m    !from getopt.f90
 implicit none
 call getarg(0,prog)

 do
  select case( getopt( "-hL:b:s:S:n:r:uw" ))
  case( 'w' )
   algorithm = 1
  case( 'L' )
   read(optarg,*)L
  case( 'b' )
   read(optarg,*)beta
  case( 's' )
   read(optarg,*)start
  case( 'S' )
   read(optarg,*)seed
  case( 'n' )
   read(optarg,*)nsweep
  case( 'r' )
   read(optarg,*)ranlux_level
  case( 'u' )
   open (28, file="/dev/urandom", access="stream", form="unformatted")
   read (28) seed
   seed = ABS(seed)
   close(28)
  case( 'h' )
   call usage
  case( '?' )
   print *, 'unknown option   ', optopt
   stop
  case( char(0)) ! done with options
   exit
  case( '-' )    ! use -- to exit from options
   exit
  case default
   print *, 'unhandled option ', optopt, ' (this is a bug)'
  end select
 enddo

end subroutine get_the_options
!=============================================
subroutine locerr(errmes)
 use global_data
 implicit none
 character(*) :: errmes
 write(0,'(A,A)') TRIM(prog),':',TRIM(errmes),' Exiting....'
 stop 1
end subroutine locerr
!=============================================
subroutine usage
 use global_data
 implicit none
 print '(3A)','Usage: ',TRIM(prog),' [options]'
 print '( A)','       -L: Lattice length (N=L*L)'
 print '( A)','       -b: beta  (options beta overrides the one in config)'
 print '( A)','       -s: start (0 cold, 1 hot, 2 old config.)'
 print '( A)','       -S: seed  (options seed overrides the one in config)'
 print '( A)','       -n: number of sweeps and measurements of E and M'
 print '( A)','       -w: use wolff algorithm for the updates'
 print '( A)','       -u: seed  from /dev/urandom'
 print '( A)','       -r: ranlux_level sets ranlux_level in RLUXGO'
 print '( A)','Monte Carlo simulation of 2d Ising Model. Metropolis is used by'
 print '( A)','default, wolff by using the -w option. Using the options, the '
 print '( A)','parameters of the simulations must be set for a new run '
 print '( A)','(start=0,1). If start=2, a config is read from the file conf.'
 stop
end subroutine usage
!=============================================
subroutine simmessage(unit)
 use global_data
 implicit none
 integer :: unit
 character(100) :: user,host,mach,tdate
 call GETLOG(user);call GETENV('HOST',host);call GETENV('HOSTTYPE',mach)
 call FDATE(tdate)
 write(unit,'( A       )')&
  '# ###################################################################'
 write(unit,'( A       )')&
  '#      2d Ising Model on a square lattice    '
 write(unit,'( 8A      )')&
  '# Run on ',TRIM(host),' (',TRIM(mach),') by ',TRIM(user),' on ',TRIM(tdate)
 write(unit,'( A,I6,A  )')'# L         = ',L,' (N=L*L)'
 write(unit,'( A,I6,A  )')'# algorithm = ',algorithm,' (0 Met/1 Wolff)'
 write(unit,'( A,I14   )')'# seed      = ',seed
 write(unit,'( A,I12,A )')'# nsweeps   = ',nsweep,' (No. of sweeps)'
 write(unit,'( A,G28.17)')'# beta      = ',beta
 write(unit,'( A,I4 ,A )')'# start     = ',start, ' (0/1/2 cold/hot/old)'
end subroutine simmessage
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
