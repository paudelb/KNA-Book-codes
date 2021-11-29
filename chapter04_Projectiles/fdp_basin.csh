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

if( $#argv != 2 )then
usage:
 cat << EOF > /dev/stderr
Usage: $prog <A> <Npoints>
EOF
 exit(1)
endif

set a0     = $argv[1]
set N      = $argv[2]
gfortran -O2 fdp_basin.f90 -o fdp_basin
./fdp_basin <<EOF
$a0 $N
EOF


# ######################################################################
# Slow version: use fdp.f90
# set omega0 = 1.0
# set omega  = 2.0
# set gamma  = 0.2
# set a0     = $argv[1]
# set STEPS  = 10000
# set TF     = 200
# set N      = $argv[2]
# gfortran -O2 fdp.f90 -o fdp

# # Produce N random initial conditions.
# # -  Pi < theta     <   Pi
# # -2 Pi < dtheta/dt < 2 Pi
# set XV0 = (`awk -v N=$N 'BEGIN{PI2=6.283185307179;srand();for(i=1;i<=N;i++){print PI2*(rand()-0.5),2.0*PI2*(rand()-0.5);}}'`)

# while($#XV0 >= 2)
# set X0 =  $XV0[1]
# shift XV0
# set V0 =  $XV0[1]
# shift XV0
# ./fdp <<EOF > /dev/null
# $omega0  $omega $gamma $a0         omega_0, omega, gamma, A
# $STEPS   0.0    $TF    $X0  $V0    STEPS,T0,TF,X0,V0
# EOF
# # echo "Done X0= $X0 V0= $V0"
# echo -n "$X0  $V0 "
# tail -n 1 fdp.dat | awk '{ print ($3>0)?1:-1;}'
# end
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
