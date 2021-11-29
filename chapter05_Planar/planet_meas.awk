#!/bin/awk -f 

# Measuring utility planet motion

$1 != "#" { # we ignore comment lines
  t  = $1;
  x  = $2;
  y  = $3;
  vx = $4;
  vz = $5;
  E  = $6;
  L  = x*vy - y*vx;

  print "E: ",t,E,L;
# We determine when vx =0, i.e. when
# the sign of vx changes
  if(vprev * vx <= 0 ){
    T   = t - Tprev;
    print "T:",t,x,y,T;
    Tprev = t;
  }
  vprev = vx;
# Calculate semimazor/semiminor axis:
  if(xprev * x <= 0 ){
    b = y - bprev;
    print "B:",t,x,y,"     :",b;
    bprev = y;
  }
  xprev = x;
  if(yprev * y <= 0 ){
    a = x - aprev
    print "A:",t,x,y,"     :",a;
    aprev = x;
  }
  yprev = y;

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
