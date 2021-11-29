#!/bin/awk -f 

# Measuring utility for the damped harmonic oscillator.
# Reads in data in the format of dlo.dat

/# omega_0=/{
  omega_0 = $3; omega = $5; gamma = $7; a_0 = $9;
  print;
}

$1 != "#" { # we ignore comment lines
  t = $1;
  x = $2;
  v = $3;
  E = $4;

# We determine the maxima of x(t). This happens when v=0, i.e. when
# the sign of v changes
  if(vprev * v <= 0 ){
    amp = (x>0)? x:-x; #absolute value of x
    T   = t - Tprev;
    print "A:",omega_0,omega,gamma,a_0, t, amp, T;
    Tprev = t;
  }
  vprev = v;
}
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
