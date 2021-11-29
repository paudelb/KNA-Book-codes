#!/bin/tcsh -f 

set cdir   = $cwd
set tdelay = ""
set skip   = 1
set x      = ""
set X      = ""
set y      = ""
set Y      = ""
set range  = 0
set findrange = 0
set prog   = `basename $0`
set argv   = ( `getopt t:d:x:y:X:Y:hr $argv`)
while ( "$argv[1]" != "--")
 switch ("$argv[1]")
  case -t:
   set tdelay = "pause $argv[2]"
   shift
   shift
   breaksw
  case -x:
   set x     = $argv[2]
   set range = 1
   shift
   shift
   breaksw
  case -X:
   set X     = $argv[2]
   set range = 1
   shift
   shift
   breaksw
  case -y:
   set y     = $argv[2]
   set range = 1
   shift
   shift
   breaksw
  case -Y:
   set Y     = $argv[2]
   set range = 1
   shift
   shift
   breaksw
  case -d:
   set skip   = $argv[2]
   shift
   shift
   breaksw
  case -r:
   set findrange = 1
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
Usage: $prog -t [sleep time] -d [skip points] <file>
Default file is rkA.dat
Other options:
   -x: set lower value in xrange
   -X: set lower value in xrange
   -y: set lower value in yrange
   -Y: set lower value in yrange
   -r: automatic determination of x-y range
EOF
 exit(1)
endif

if($#argv >= 1 )then
 set file = $argv[1]
else
 set file = rkA.dat
endif

# See if the range of the plot is automatic or set by user:
if($range)then
 set xyrange = "[${x}:${X}][${y}:${Y}]"
else
 set xyrange = ""
endif
if( $findrange )then #determine x-y range by extreme values:
 set xy = (`awk 'BEGIN{x=1e200;X=-x;y=x;Y=X}{if($2<x){x=$2};if($2>X){X=$2};if($3<y){y=$3};if($3>Y){Y=$3};if($6<x){x=$6};if($6>X){X=$6};if($7<y){y=$7};if($7>Y){Y=$7};}END{dx=0.03*(X-x);dy=0.03*(Y-y);print x-dx,X+dx,y-dy,Y+dy}' $file`)
 set xyrange = "[${xy[1]}:${xy[2]}][${xy[3]}:${xy[4]}]"
endif
 

# ##########################################################
# This is the heart of the script. You can skip all of the
# above if you do not care about options and determinint the
# plot range
############################################################
onintr cleanup
set tmp    = tmp.$prog.gplt.$$
set nlines = `wc -l $file|awk '{print $1}'` 
cat  <<EOF > $tmp
icount = icount+$skip
plot $xyrange "<cat -n $file"  \
  using 3:(\$1<= icount ? \$4: 1/0) with lines t "1",\
  "<cat -n $file"  \
  using 7:(\$1<= icount ? \$8: 1/0) with lines t "2"
$tdelay
if(icount < $nlines ) reread
EOF

gnuplot -persist <<EOF
icount = 10
set size square
load "$tmp"
EOF

cleanup:
if( -f $tmp    ) /bin/rm -f $tmp
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
