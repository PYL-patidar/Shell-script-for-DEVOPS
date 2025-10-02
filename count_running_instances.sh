#!/bin/bash

<<count
this scrit for count the number of running instances
count

count_running_instances(){
	echo "counting running instances...."
	aws ec2 describe-instances \
		--filter "Name=instance-state-name,Values=Stoped" \
		--query "Reservation[*].Instances[*].InstanceId" \
		--output text | wc -l

}
count_running_instances
