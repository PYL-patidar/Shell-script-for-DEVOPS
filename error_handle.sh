#!/bin/bash 
 
<<comment

this is an error handing script 
comment


create_dir(){
	mkdir demo
	
}

if ! create_dir ; then 
	echo "directory already exists"
	exit 1
fi

echo "this should not work because the code is interruoted"

