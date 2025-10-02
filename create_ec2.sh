#!/bin/bash

set -euo pipefail

<<comment

this file is about the integration of shell-scipting and AWS

comment

check_awscli() {
	    if ! command -v aws &> /dev/null; then
		            echo "AWS CLI is not installed. Please install it first." >&2
	                    return 1
	    fi
}

install_awscli(){

	echo "installation started of AWS-ClI in linux........"

	curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
	sudo apt-get install -y unzip &> /dev/null
	unzip -q awscliv2.zip
	sudo ./aws/install

	#verify installtion
	aws --version

	#clean up
	rm -rf awscliv2.zip ./aws
}

wait_for_instance() {
	local instance_id="$1"

	echo "Waiting for instance $instance_id to be in running state..."

	while true ;
	do
		state=$(aws ec2 describe-instances
	       	--instance-ids "$instance_id" \
	       	--query 'Reservations[0].Instances[0].State.Name' \
	       	--output text)


		if [[ "$state" == "running" ]] ; then
			echo "Instance $instance_id  is now running."
		        break
		fi
	        sleep 10 
	done	

}


create_EC2_instance() {
	local ami_id="$1"
	local instance_type="$2"
	local key_name="$3"
	local subnet_id="$4"
	local security_group="$5"
	local instance_name="$6"

	instance_id=$(aws ec2 run-instances \
		--image-id "$ami_id" \
		--instance-type "$instance_type" \
		--key-name "$key_name" \
		--subnet-id "$subnet_id" \
		--security-group-ids "$security_group" \
		--tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance_name}]" \
		--query 'Instances[0].InstanceId' \
		--output text
	)

	if [[ -z "$instance_id" ]] ; then
		echo "Fail to create instance."
		exit 1
	fi

	echo "Instance $instance_id created successfully"

	#Wait for the instance to be running state
	
	wait_for_instance "$instance_id"
}


main(){  
	#check AWS cli is installerd or not 
	if ! check_awscli ; then
		install_awscli
		exit 1
	fi

	echo "Create EC2 instance......"

	#specify the parameters for creating the EC2 instance
	AMI_ID="ami-02d26659fd82cf299"
	INSTANCE_TYPE="t3.micro"
	KEY_NAME="Linux-VM-key"
	SUBNET_ID="subnet-04f1ed8f604920b26"
	SECURITY_GROUP="sg-04cf7414996b2b540"
	INSTANCE_NAME="Shell-script-EC2-instance"

	#call the function to create the EC2 instance 
	create_EC2_instance "$AMI_ID" "$INSTANCE_TYPE" "$KEY_NAME" "$SUBNET_ID" "$SECURITY_GROUP" "$INSTANCE_NAME"

	echo "EC2 instance creation completed...."
}

main "$@"
