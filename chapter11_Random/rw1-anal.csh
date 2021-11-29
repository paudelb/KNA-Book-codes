#!/bin/tcsh -f 
# 
# Simple shell script to analyze data from the program rw1.c
# To see data run as:
# > gfortran -O2 rw1.f90 drandom.d90 -o rw1
# > rw1-anal.csh > rw1-anal.out
# > grep ^R2 rw1-anal.out
# > grep ^n  rw1-anal.out
# etc. etc.
# To plot results:
# > gnuplot
# gnuplot> plot "<grep ^R2 rw1-anal.out" using 2:3:5 title "R2"
# gnuplot> plot "<grep ^n  rw1-anal.out" using 2:3:5 title "n"
set Nwalk = 10000
set Ns    = (16 32 64 128 256 512 1024 2048 4096 8192 16384 \
             32768 65536 131072)

foreach N ($Ns)
 ./rw1 $Nwalk $N > rwalk.$N.dat
 echo -n "R2  $N  " # Compute 
 grep ^R rwalk.$N.dat | awk '{print $3}' | ./average
 echo -n "x   $N  "
 grep ^R rwalk.$N.dat | awk '{print $4}' | ./average
 echo -n "y   $N  "
 grep ^R rwalk.$N.dat | awk '{print $5}' | ./average
 echo -n "n   $N  "
 grep ^R rwalk.$N.dat | awk '{print $6}' | ./average
end
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
