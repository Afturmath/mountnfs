#!/bin/bash
#
# NFS multi-mount script
# Author: Kevin Dougherty (kevin[at]afturmath[dot]com
# Version 0.2
# Changelog:
# 0.2 -- Renamed variables for nfs centric scheme
# 0.2 -- added help
# 0.2 -- added debug mode
# 0.1 -- initial release
#
# Todo
# - Add options for variables instead of static definitions
# - Test to see if the input mount is already mounted

# Set variables (defined in help)
nroot=
nfs_srv=
nfs_dir=
ndebug=0

if [[ ! "$nroot" ]]; then
    echo "Error: nroot must be set in the script variables"
    exit
fi
if [[ ! "$nfs_srv" ]]; then
    echo "Error: nfs_srv must be set in the script variables"
    exit
fi
if [[ ! "$nfs_dir" ]]; then
    echo "Error: nfs_dir must be set in the script variables"
    exit
fi

printhelp(){
    echo "mountnfs.sh"
    echo 
    echo "Usage:"
    echo "mountnfs <volume names>"
    echo 
    echo "Example:"
    echo "mountnfs m1 m2 m3"
    echo "The above would mount 3 nfs volumes exported on the server, m1, m2, and m3"
    echo
    echo 'The following varibles can be set in this script'
    echo '"nroot" -- absolute path to the parent mount point on this host'
    echo '"nfs_srv" -- nfs server hostname or IP address'
    echo '"nfs_dir" -- absolute directory on the nfs server where all exports live'
    echo 
}

# Check to ensure some mounts were passed in as input, otherwise print help
if [ $# -ge 1 ]; then
    while [ $# -ne 0 ]; do
	ndisk_in=$(echo $ndisk_in $1);
	if [[ $ndebug = 1 ]]; then
	    echo "current input = $1"
	    echo "ndisk_in = $ndisk_in"
	    echo "remaining paramaters: $#";
	fi
	shift;
    done
else 
    echo "No input data!"
    printhelp
fi

# Mount the actual volumes
mountvols(){
    if [[ $ndebug = 1 ]]; then
	echo "sudo mount -t nfs $nfs_srv:$nfs_dir/$ndisk $nmount";
	echo "Debug mode: removing $nmount"
	rmdir $nmount
    else
	sudo mount -t nfs $nfs_srv:$nfs_dir/$ndisk $nmount
	sudo chown $USER: $nmount
	echo "Successfully Mounted $nfs_srv:$nfs_dir/$ndisk to $nmount"
    fi
}

# Prompt the user to create a mount point if one doesn't exist
mkmntdir(){
	read -p "$nmount doesn't exist. Would you like to create it [y/n]? " mknmount;
	    case $mknmount in
		y) 
		    sudo mkdir $nmount
		    echo "Created $nmount"
		    ;;
		n) 
		    echo "Skipping $nmount"
		    ;;
		*)
		    echo 'Invalid input. Please answer "y" or "n".';
		    mkmntdir;
		    ;; 
	    esac;
}

# for each mount input, ensure it's a dir (mkmntdir if not), then mountvols it
for ndisk in $ndisk_in; do
    nmount=$nroot/$ndisk
    mountcheck=$(mount -l -t nfs | awk -v nmount=$nmount '$3 ~ nmount {print $3}')
    if [[ $ndebug = 1 ]]; then
	echo "ndisk = $ndisk"
	echo "nmount = $nmount"
	echo "mountcheck = $mountcheck"
    fi
    if [[ "$nmount" = "$mountcheck" ]]; then
	echo "$nmount is already mounted!"
	echo "Please remove \"$ndisk\" from the commands and re-run mountnfs."
	exit
    fi
    while [[ ! -d $nmount ]]; do
	mkmntdir
    done
    mountvols
done
