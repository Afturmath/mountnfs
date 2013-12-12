mountnfs
========

This simple script can be used to mount NFS volumes in bulk by passing user-friendly volume names as arguments.


 NFS multi-mount script

 Author: Kevin Dougherty (kevin[at]afturmath[dot]com)

 Version 0.2

 Changelog:
 0.2 -- Renamed variables for nfs centric scheme
 0.2 -- added help
 0.2 -- added debug mode
 0.1 -- initial release

 Pending featuers
 - Add options for variables instead of static definitions
 - Test to see if the input mount is already mounted

 Usage:
    mountnfs <volume names>

 Example:
    mountnfs m1 m2 m3

 The above would mount 3 nfs volumes exported on the server, m1, m2, and m3

 The following varibles can be set in this script
 nroot -- absolute path to the parent mount point on this host
 nfs_srv -- nfs server hostname or IP address
 nfs_dir -- absolute directory on the nfs server where all exports live

