#!/bin/bash
 
<<comment 

 this is loop script 
comment
for (( i=$2 ; i<=$3 ; i++ ))
do
	mkdir $1$i
done
