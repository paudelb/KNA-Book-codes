#!/bin/bash
# Run this script as:
# ./script04.sh Hello this is a bash script
#----------------------------------------------------------------------
# `command` is command substitution: it is replaced by stdout of command
now=`date`; mypc=`uname -a`
# Print information: variables are expanded within double quotes
echo "I am user $user working on the computer $HOSTNAME" #HOST is predefined
echo "Today the date is      :  $now"                    #now  is defined above
echo "My home directory is   :  $HOME"                   #HOME is predefined
echo "My current directory is:  $PWD"                    #PWD changes with cd
echo "My computer runs       :  $mypc"                   #mypc is defined above
echo "My process id is       :  $$   "                   #$$   is predefined
# Manipulate the command line: ($# is number of elements in $1, $2, $3, ...)
echo "The command line has $# arguments" 
echo "The name of the command I am running is: $0"   
echo "All arguments                          : $@"   
echo "All arguments                          : $1, $2, $3, $4, $5, $6"      
echo "Arguments 3rd to last of the command   : ${@: 3:100}"    #third to last
echo "The last argument is                   : ${@: -1}" #last element

read  -p "Enter radii of circles: " -a  Rs
if (( ${#Rs[*]} <  10 ));then
 echo "Need more than 10 radii. Exiting...."
 exit 1
fi
echo "You entered ${#Rs[*]} radii, the first is ${Rs[0]} and the last ${Rs[*]:(${#Rs[*]}-1)}"
echo "Rs= ${Rs[*]}"
for R in "${Rs[@]}";do
 l=`awk -v rad=$R 'BEGIN{print 2*atan2(0,-1)*rad}'`
 echo "Circle with R= $R has perimeter $l"
done
# acalc is a shell function: $* are its arguments, then you can use awk as a calculator
acalc     (){ awk  -v OFMT="%.17g" "BEGIN{print $* }"; }
echo "Using acalc to compute       2+3=" `acalc "2+3"`
echo "Using acalc to compute cos(2*pi)=" `acalc "cos(2*atan2(0,-1))"`
# Now do the same loop over radii as above in a different way:
for R in "${Rs[@]}";do
 a=`acalc "atan2(0,-1)*${R}*${R}"`
 # construct a filename to save the result from the value of R:
 file=area${R}.dat
 echo "Circle with R= $R has area $a" > $file #save result in a file
done
# Now look for our files: save their names in an array files:
files=(`ls -1 area*.dat`)
if (( ${#files[*]} == 0 ));then echo "Sorry, no area files found";exit 1;fi
echo "--------------------------------------------"
echo "files: ${files[@]}"
ls -l "${files[@]}"
echo "--------------------------------------------"
echo "And the results for the area are:"
for f in "${files[@]}";do
 echo -n "file ${f}: "
 cat $f
done
# now play a little bit with file names:
echo "--------------------------------------------"
f=${files[0]}
# -f, -r, -w, -x, -d test existence of file, rwxd permissions
# the ! negates the expression (true -> false, false -> true)
if [   -f $f      ];then echo "$file exists";fi
if [   -r $f      ];then echo "$file is readable by me";fi
if [   -w $f      ];then echo "$file is writable by me";fi
if [ ! -w /bin/ls ];then echo "/bin/ls is NOT writable by me";fi
if [ ! -x $f      ];then echo "$file is NOT an executable";fi
if [   -x /bin/ls ];then echo "/bin/ls is executable by me";fi
if [ ! -d $f      ];then echo "$file is NOT a directory";fi
if [   -d /bin    ];then echo "/bin is a directory";fi
echo "--------------------------------------------"
# transform the name of a file
f=${PWD}/$f
base=`basename $f` # removes directory name
fdir=`dirname $f`  # gets    directory of $f
extension=${f#*.}  # gets    extension .dat
filename=`basename $f .${f#*.}`
echo "file      is: $f"
echo "filename  is: $filename"
echo "extension is: $extension"
echo "directory is: $fdir"
echo "basename  is: $base"
# now transform the name to one with different extension:
newfile=${filename}.jpg
echo "jpeg name is: $newfile"
if [ ${newfile#*.} == jpg ];then echo $newfile is a picture;fi
echo "--------------------------------------------"
# Now save all data in a file using a "here document"
# A here document starts with <<EOF and ands with a line 
# starting exactly with EOF (EOF can be any string as below)
# In a "here document" we can use variables and command 
# substitution:
cat <<AREAS >> areas.dat
# This file contains the areas of circle of given radii
# Computation done by ${USER} on ${HOSTNAME}. Today is `date`
`cat ${files[@]}`
AREAS
if [ -f areas.dat ];then cat areas.dat;fi
# You can use a "here document" as standard input to any command:
# use gnuplot to save a plot: gnuplot does the job and exits...
gnuplot <<GNU
set terminal jpeg
set output   "areas.jpg"
plot "areas.dat" using 4:7 title "areas.dat",\
     pi*x*x                title "pi*R^2"
set output
GNU
# check our results: display the jpeg file using eog
if [ -f areas.jpg ];then
 eog areas.jpg &
fi

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








   






 
