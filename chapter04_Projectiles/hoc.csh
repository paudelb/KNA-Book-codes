#!/bin/tcsh -f 
# 
# Script to run euler methods for several values of stepseu
#

set X0   = 0.2
set V0   = 0.0
set tf   = 6.0
set maxsteps = 110000

set cdir = $cwd
set prog = `basename $0`
set argv = ( `getopt T:hx:v:t: $argv`)
set exact_sol = 1 # whether to plot simple pendulum solution
while ( "$argv[1]" != "--")
 switch ("$argv[1]")
  case -x:
   set X0 = $argv[2]
   shift
   shift
   breaksw
  case -v:
   set V0 = $argv[2]
   shift
   shift
   breaksw
  case -t:
   set tf = $argv[2]
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
Usage: $prog [-x <X_0>] [-v <V_0>] [-t <t_f>] <steps>
 Harmonic Oscillator test program.
 Run euler and rk4 for different values of number of steps (<$maxsteps)
EOF
 exit(1)
endif

if($#argv < 1)then
 set steps = (100 500 1000 2000 5000 7000 9999)
else
 set steps = ($argv)
endif

# first compile all necessary source files:
foreach p (hoc_euler hoc_rk)
 if( -f $p.f90)then
  gfortran $p.f90 -o $p
 else
  echo "${prog}: $p.f90 not found. Exiting"
  exit(1)
 endif
end

# cleaning old data files
if( -f euler.all        ) \rm -f euler.all
if( -f euler_cromer.all ) \rm -f euler_cromer.all
if( -f euler_verlet.all ) \rm -f euler_verlet.all
if( -f rk.all           ) \rm -f rk.all
# preparing gnuplot plot commands for STEPS plots
set pltx_e  = "plot "
set pltx_ec = "plot "
set pltx_ev = "plot "
set pltx_rk = "plot "
set pltv_e  = "plot "
set pltv_ec = "plot "
set pltv_ev = "plot "
set pltv_rk = "plot "
set plte_e  = "plot "
set plte_ec = "plot "
set plte_ev = "plot "
set plte_rk = "plot "
# Now running for each value of STEPS:
@ scnt = 0 # count index in $steps in the loopt
foreach s ($steps)
 if( $s >= $maxsteps )then
  echo "${prog}: steps= $s is >= $maxsteps. Skipping...."
  goto skip_step
 endif
 echo -n "Working on X0= $X0 V0= $V0 tf= $tf  STEPS= $s ...."
# Running the program:
 ./hoc_euler <<EOF > /dev/null
$X0 $V0 $tf $s
EOF

 ./hoc_rk <<EOF > /dev/null
$s 0.0 $tf $X0 $V0
EOF
# Making the plots:
 gnuplot -persist << EOF
set dummy t  #t is the independent variable in functions
set style data lines
omega2  = 10  #This is g/l in program
X0      = $X0 #Amplitute of oscillation
V0      = $V0 #Velocity at t0
omega   = sqrt(omega2)
x(t)    = X0 * cos(omega * t) +(V0/omega)*sin(omega*t)
v(t)    = V0 * cos(omega * t) -(omega*X0)*sin(omega*t)

set term x11 1
set title "Positions. STEPS= $s"
set ylabel "{/Symbol q}"
set xlabel "t"
plot "euler.dat" using 1:2  title "Euler", \
     "euler_cromer.dat" using 1:2  title "Euler-Cromer", \
     "euler_verlet.dat" using 1:2  title "Euler-Verlet", \
     "rk.dat"           using 1:2  title "RK4", \
     x(t) title "{/Symbol q}_s(t)"
set term postscript enhanced color eps
set out "eulerX0${X0}V0${V0}_xs$s.eps"
set title ""
replot
set out
set term x11

set term x11 2
set title "Velocities. STEPS= $s"
set ylabel "{/Symbol v}"
set xlabel "t"
plot "euler.dat" using 1:3  title "Euler", \
     "euler_cromer.dat" using 1:3  title "Euler-Cromer", \
     "euler_verlet.dat" using 1:3  title "Euler-Verlet", \
     "rk.dat"           using 1:3  title "RK4", \
     v(t) title "v_s(t)"
set term postscript enhanced color eps
set out "eulerX0${X0}V0${V0}_vs$s.eps"
set title ""
replot
set out
set term x11
EOF

# Preparing
 echo -n " Processing data....." 
 foreach f (euler euler_cromer euler_verlet rk)
# We print the deviation from the known solution:
  cat $f.dat | awk -v X0=$X0 -v V0=$V0 -v omega2=10 'BEGIN{E0=0.5*V0*V0+0.5*omega2*X0*X0;}{omega=sqrt(omega2);t=$1;x=$2;v=$3;E=$4;x0=X0 * cos(omega * t) +(V0/omega)*sin(omega*t);v0=V0 * cos(omega * t) -(omega*X0)*sin(omega*t);dx=x-x0;dv=v-v0;dE=E-E0;dx=(dx>0)?dx:-dx;dv=(dv>0)?dv:-dv;dE=(dE>0)?dE:-dE;print t,dx,dv,dE;}'>> $f.all
  echo "\n"  >> $f.all
 end 

 set pltx_e  = "$pltx_e   'euler.all'        using 1:2 index $scnt title '$s',"
 set pltx_ec = "$pltx_ec  'euler_cromer.all' using 1:2 index $scnt title '$s',"
 set pltx_ev = "$pltx_ev  'euler_verlet.all' using 1:2 index $scnt title '$s',"
 set pltx_rk = "$pltx_rk  'rk.all'           using 1:2 index $scnt title '$s',"
 set pltv_e  = "$pltv_e   'euler.all'        using 1:3 index $scnt title '$s',"
 set pltv_ec = "$pltv_ec  'euler_cromer.all' using 1:3 index $scnt title '$s',"
 set pltv_ev = "$pltv_ev  'euler_verlet.all' using 1:3 index $scnt title '$s',"
 set pltv_rk = "$pltv_rk  'rk.all'           using 1:3 index $scnt title '$s',"
 set plte_e  = "$plte_e   'euler.all'        using 1:4 index $scnt title '$s',"
 set plte_ec = "$plte_ec  'euler_cromer.all' using 1:4 index $scnt title '$s',"
 set plte_ev = "$plte_ev  'euler_verlet.all' using 1:4 index $scnt title '$s',"
 set plte_rk = "$plte_rk  'rk.all'           using 1:4 index $scnt title '$s',"

 @ scnt++
 echo "Done!"    
skip_step:
end

# If we want the simple pendulum solution we add it as the last function
# to plo
# if( $exact_sol) then
#  set pltx_e  = "$pltx_e   x(t) title '{/Symbol q}_s(t)'"
#  set pltx_ec = "$pltx_ec  x(t) title '{/Symbol q}_s(t)'"
#  set pltx_ev = "$pltx_ev  x(t) title '{/Symbol q}_s(t)'"
#  set pltx_rk = "$pltx_rk  x(t) title '{/Symbol q}_s(t)'"
#  set pltv_e  = "$pltv_e   v(t) title 'v_s(t)'"
#  set pltv_ec = "$pltv_ec  v(t) title 'v_s(t)'"
#  set pltv_ev = "$pltv_ev  v(t) title 'v_s(t)'"
#  set pltv_rk = "$pltv_rk  v(t) title 'v_s(t)'"
# else
# else we plot something not plotable
 set pltx_e  = "$pltx_e   1/0 notit"
 set pltx_ec = "$pltx_ec  1/0 notit"
 set pltx_ev = "$pltx_ev  1/0 notit"
 set pltx_rk = "$pltx_rk  1/0 notit"
 set pltv_e  = "$pltv_e   1/0 notit"
 set pltv_ec = "$pltv_ec  1/0 notit"
 set pltv_ev = "$pltv_ev  1/0 notit"
 set pltv_rk = "$pltv_rk  1/0 notit"
 set plte_e  = "$plte_e   1/0 notit"
 set plte_ec = "$plte_ec  1/0 notit"
 set plte_ev = "$plte_ev  1/0 notit"
 set plte_rk = "$plte_rk  1/0 notit"
# endif

gnuplot -persist<<EOF
set dummy t  #t is the independent variable in functions
set style data lines
omega2  = 10  #This is g/l in program
X0      = $X0 #Amplitute of oscillation
V0      = $V0 #Velocity at t0
omega   = sqrt(omega2)
x(t)    = X0 * cos(omega * t) +(V0/omega)*sin(omega*t)
v(t)    = V0 * cos(omega * t) -(omega*X0)*sin(omega*t)
energy  = 0.5 * V0 * V0 + 0.5 * 10.0 * X0 * X0

set xrange [0.1:]
set log 
set term x11 1
set title "Positions: Euler Method"
set ylabel "{/Symbol d}x"
set xlabel "t"
$pltx_e
set term postscript enhanced color eps
set out "hoc.euler.STEPS_X0${X0}V0${V0}_x.eps"
set title ""
replot
set out
set term x11

set term x11 2
set title "Velocities: Euler Method"
set ylabel "{/Symbol d}v"
set xlabel "t"
$pltv_e
set term postscript enhanced color eps
set out "hoc.euler.STEPS_X0${X0}V0${V0}_v.eps"
set title ""
replot
set out
set term x11

set term x11 9
set title "Energy: Euler Method"
set ylabel "{/Symbol d}E"
set xlabel "t"
$plte_e
set term postscript enhanced color eps
set out "hoc.euler.STEPS_X0${X0}V0${V0}_e.eps"
set title ""
replot
set out
set term x11

set term x11 3
set title "Positions: Euler-Cromer Method"
set ylabel "{/Symbol d}x"
set xlabel "t"
$pltx_ec
set term postscript enhanced color eps
set out "hoc.euler_cromer.STEPS_X0${X0}V0${V0}_x.eps"
set title ""
replot
set out
set term x11

set term x11 4
set title "Velocities: Euler-Cromer Method"
set ylabel "{/Symbol d}v"
set xlabel "t"
$pltv_ec
set term postscript enhanced color eps
set out "hoc.euler_cromer.STEPS_X0${X0}V0${V0}_v.eps"
set title ""
replot
set out
set term x11

set term x11 10
set title "Energy: Euler-Cromer Method"
set ylabel "{/Symbol d}E"
set xlabel "t"
$plte_ec
set term postscript enhanced color eps
set out "hoc.euler_cromer.STEPS_X0${X0}V0${V0}_e.eps"
set title ""
replot
set out
set term x11

set term x11 5
set title "Positions: Euler-Verlet Method"
set ylabel "{/Symbol d}x"
set xlabel "t"
$pltx_ev
set term postscript enhanced color eps
set out "hoc.euler_verlet.STEPS_X0${X0}V0${V0}_x.eps"
set title ""
replot
set out
set term x11

set term x11 6
set title "Velocities: Euler-Verlet Method"
set ylabel "{/Symbol d}v"
set xlabel "t"
$pltv_ev
set term postscript enhanced color eps
set out "hoc.euler_verlet.STEPS_X0${X0}V0${V0}_v.eps"
set title ""
replot
set out
set term x11

set term x11 11
set title "Energy: Euler-Verlet Method"
set ylabel "{/Symbol d}E"
set xlabel "t"
$plte_ev
set term postscript enhanced color eps
set out "hoc.euler_verlet.STEPS_X0${X0}V0${V0}_e.eps"
set title ""
replot
set out
set term x11

set term x11 7
set title "Positions: RK4 Method"
set ylabel "{/Symbol d}x"
set xlabel "t"
$pltx_rk
set term postscript enhanced color eps
set out "hoc.rk.STEPS_X0${X0}V0${V0}_x.eps"
set title ""
replot
set out
set term x11

set term x11 8
set title "Velocities: RK4 Method"
set ylabel "{/Symbol d}v"
set xlabel "t"
$pltv_rk
set term postscript enhanced color eps
set out "hoc.rk.STEPS_X0${X0}V0${V0}_v.eps"
set title ""
replot
set out
set term x11

set term x11 12
set title "Energy: RK4 Method"
set ylabel "{/Symbol d}E"
set xlabel "t"
$plte_rk
set term postscript enhanced color eps
set out "hoc.rk.STEPS_X0${X0}V0${V0}_e.eps"
set title ""
replot
set out
set term x11

EOF
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
