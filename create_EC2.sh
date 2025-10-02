#!/bin/bash

<<comment
this script is for create ec2 machine 
comment

create_EC2(){
	echo "creating the ec2 machine of name is :$1"

	aws ec2 run-instances \
	--image-id "$2" \
	--instance-type "$3" \
	--key-name "$4" \
	--subnet-id "$5"  \
	--security-group-ids "$6" \
	--tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$1}]"

	echo "Instance created successfully...."
}

create_EC2 "$@"
