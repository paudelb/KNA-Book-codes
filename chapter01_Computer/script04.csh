#!/bin/tcsh -f 
# Run this script as:
# ./script04.csh Hello this is a tcsh script
#----------------------------------------------------------------------
# `command` is command substitution: it is replaced by stdout of command
set now = `date` ; set mypc = `uname -a`
# Print information: variables are expanded within double quotes
echo "I am user $user working on the computer $HOST" #HOST is predefined
echo "Today the date is      :  $now"                #now  is defined above
echo "My home directory is   :  $home"               #home is predefined
echo "My current directory is:  $cwd"                #cwd changes with cd
echo "My computer runs       :  $mypc"               #mypc is defined above
echo "My process id is       :  $$   "               #$$   is predefined
# Manipulate the command line: ($#argv is number of elements in array argv)
echo "The command line has $#argv arguments" 
echo "The name of the command I am running is: $0"         
echo "Arguments 3rd to last of the command   : $argv[3-]"    #third to last
echo "The last argument is                   : $argv[$#argv]" #last element
echo "All arguments                          : $argv"

# Ask user for input: enter radii of circles
echo -n "Enter radii of circles: " # variable $< stores one line of input
set  Rs = ($<)  #Rs is now an array with all words entered by user
if($#Rs < 10 )then #make a test, need at least 10 of them
 echo "Need more than 10 radii. Exiting...."
 exit(1)
endif
echo "You entered $#Rs radii, the first is $Rs[1] and the last $Rs[$#Rs]"
echo "Rs= $Rs"
# Now, compute the perimeter of each circle:
foreach R ($Rs)
 # -v rad=$R set the awk variabel rad equal to $R. pi=atan2(0,-1)=3.14...
 set l = `awk -v rad=$R 'BEGIN{print 2*atan2(0,-1)*rad}'` 
 echo "Circle with R= $R has perimeter $l"
end
# alias defines a command to do what you want: use awk as a calculator
alias acalc  'awk "BEGIN{print \!* }"' # \!* substitutes args of acalc
echo "Using acalc to compute       2+3=" `acalc 2+3`
echo "Using acalc to compute cos(2*pi)=" `acalc cos(2*atan2(0,-1))`
# Now do the same loop over radii as above in a different way
# while( expression ) is executed as long as "expression" is true
while($#Rs > 0) #executed as long as $Rs contains radii
 set R = $Rs[1] #take first element of $Rs
 shift Rs       #now $Rs has one less element:old $Rs[1] has vanished
 set a = `acalc atan2(0,-1)*${R}*${R}` # =pi*R*R calculated by acalc
 # construct a filename to save the result from the value of R:
 set file = area${R}.dat
 echo "Circle with R= $R has area $a" > $file #save result in a file
end             #end while
# Now look for our files: save their names in an array files:
set files = (`ls -1 area*.dat`)
if( $#files == 0) echo "Sorry, no area files found"
echo "--------------------------------------------"
echo "files: $files"
ls -l $files
echo "--------------------------------------------"
echo "And the results for the area are:"
foreach f ($files)
 echo -n "file ${f}: "
 cat $f
end
# now play a little bit with file names:
echo "--------------------------------------------"
set f = $files[1] # test permissions on first file
# -f, -r, -w, -x, -d test existence of file, rwxd permissions
# the ! negates the expression (true -> false, false -> true)
echo "testing permissions on files:"
if(  -f $f     ) echo "$file exists"
if(  -r $f     ) echo "$file is readable by me"
if(  -w $f     ) echo "$file is writable by be"
if(! -w /bin/ls) echo "/bin/ls is NOT writable by me"
if(! -x $f     ) echo "$file is NOT an executable"
if(  -x /bin/ls) echo "/bin/ls is executable by me"
if(! -d $f     ) echo "$file is NOT a directory"
if(  -d /bin   ) echo "/bin is a directory"
echo "--------------------------------------------"
# transform the name of a file
set f = $cwd/$f       # add the full path in $f
set filename  = $f:r  # removes extension .dat
set extension = $f:e  # gets    extension .dat
set fdir      = $f:h  # gets    directory of $f
set base      = `basename $f` # removes directory name
echo "file      is: $f"
echo "filename  is: $filename"
echo "extension is: $extension"
echo "directory is: $fdir"
echo "basename  is: $base"
# now transform the name to one with different extension:
set newfile = ${filename}.jpg
echo "jpeg name is: $newfile"
echo "jpeg base is:" `basename $newfile`
if($newfile:e == jpg)echo `basename $newfile` " is a picture"
echo "--------------------------------------------"
# Now save all data in a file using a "here document"
# A here document starts with <<EOF and ands with a line 
# starting exactly with EOF (EOF can be any string as below)
# In a "here document" we can use variables and command 
# substitution:
cat <<AREAS >> areas.dat
# This file contains the areas of circle of given radii
# Computation done by ${user} on ${HOST}. Today is `date`
`cat $files`
AREAS
# now see what we got:
if( -f areas.dat) cat areas.dat
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
if( -f areas.jpg) eog areas.jpg &

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
