!============== end.f90     ==================
subroutine endsim()
 use global_data
 implicit none
 integer,parameter :: f_out = 17
 integer           :: i,seeds(25)

 call RLUXUT(seeds)
 call rename('conf','conf.old')
 open(unit=f_out,file='conf')
 write(f_out,'(A)')&
  '# Configuration of 2d Ising model on square lattice. Parameters (N=Lx*Ly) and s(N)'
 write(f_out,'(A4,I5,A4,I5,A6,G28.17,A6,25I16)')&
  'Lx= ',L,' Ly= ',L,' beta= ',beta,' seed= ',seeds
 do i=1,N
  write(f_out,'(I3)')s(i)
 enddo
 close(f_out)
 if(algorithm .eq. 0)              &
 print '(A,F7.3)','# acceptance= ',&
  acceptance/DBLE(N)/DBLE(nsweep)
end subroutine endsim
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
