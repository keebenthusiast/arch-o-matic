Various Arch install scripts I've made for my own purpose, fork as you wish!

#To use them: 

start out with copying the installation scripts to a flash drive.
then boot to an arch image via a CD ( working out the bugs with flash drive boot up ).

in the Arch bootable media, make a directory called USB: 
<code>mkdir USB</code>

mount your flash drive to the USB directory ( mine was /dev/sdb1 ): 
<code>mount /dev/sdb1 USB</code>

change over to the directory: 
<code>cd USB</code>

execute the script that you want to execute: 
<code>sh nameOfScript.sh</code> 

and have fun.
