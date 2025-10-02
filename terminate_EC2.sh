#!/bin/bash

<<comment
this is for terminate the ec2 machine 
comment

terminate_EC2(){
	echo "terminating the $1  ....."

	aws ec2 terminate-instances --instance-ids "$1"
}

terminate_EC2 "$@"
