#!/bin/tcsh -f 

set cdir = $cwd
set prog = `basename $0`
set argv = ( `getopt T:h $argv`)
while ( "$argv[1]" != "--")
 switch ("$argv[1]")
  case -T:
   set T = $argv[2]
   shift
   shift
   breaksw
  case -h:
   goto usage
   shift
   breaksw
 endsw
end   # while
shift # get rid of --

if( $#argv < 0 )then
usage:
 cat << EOF > /dev/stderr
Usage: $prog
EOF
 exit(1)
endif

set Q       = -10
set epsilon = 1e-6
set omegas  = (1.0 1.2) #1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0 2.1 2.2 2.4)
echo "# G-S,omega= $omegas"
set exe    = psor
gfortran PoissonEq.f90    -o $exe
set r =  `(echo 0 0 0 0;echo $Q;echo $epsilon 1  )| $exe | grep err | awk '{print $1}'`
echo -n "$r "
gfortran PoissonEqSOR.f90 -o $exe
foreach om ($omegas)
 set r = `(echo 0 0 0 0;echo $Q;echo $epsilon $om)| $exe | grep err | awk '{print $1}'`
 echo -n "$r "
end
echo " "
#  ---------------------------------------------------------------------
#  Copyright by Konstantinos N. Anagnostopoulos (2004-2014)
#  Physics Dept., National Technical University,
#  konstant@mail.ntua.gr, www.physics.ntua.gr/~konstant
#  
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, version 3 of the License.
#  
#  This program is distributed in the hope that it will be useful, but
#  WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
#  General Public License for more details.
#  
#  You should have received a copy of the GNU General Public Liense along
#  with this program.  If not, see <http://www.gnu.org/licenses/>.
#  -----------------------------------------------------------------------
