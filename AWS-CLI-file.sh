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

	curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
	unzip awscliv2.zip
	sudo ./aws/install

	#verify installtion
	aws --version

	#clean up
	rm -rf awscliv2.zip ./aws
}

wait_for_instance(){

	local instance_id="$1"

	echo "Waiting for instance $instance_id to be in running state..."

	while true;
	do
		state=$(aws ec2 describe-instance --instance-ids "$instance_id" --query 'Reservation[0].Instance[0].state.Name' --output text)
		if [["$state" == "running" ]];then
			echo "Instance $instance_id  is now running."
		        break
		fi
	        sleep 10 
	done	

}





create_EC2_instance(){

	echo "creating EC2 instance processing......."

	local instance_name="$1"
	local AMI_ID="$2"
	local instance_type="$3"
	local key_name="$4"
	local subnet_ID="$5"
	local security_group="$6"

	#RUN AWS CLI commant to create ec2 instance 
	instance_id=$(aws ec2 run-instances \ 
		--image-id "$AMI_ID" \
		--instance-type "$instance_type" \
		--key-name "$key_name" \
		--subnet-id "$subnet_ID" \
		--security-group-ids "$security_group" \
		--tag-specification "ResourceType=instance, Tags=[{Key=Name,Value=instance_name}]" \

		--query 'Instance[0].InstanceId' \
i	--output text
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
	INSTANCE_NAME="Shell-script-EC2-instance" 
	AMI_ID="ami-02d26659fd82cf299"
	INSTANCE_TYPE="t3.micro"
	KEY_NAME="Linux-VM-key"
	SUBNET_ID="subnet-07ebbae2fb6ae3eb5"
	SECURITY_GROUP="sg-0881f650935b19656"

	#call the function to create the EC2 instance 
	create_EC2_instance "$INSTANCE_NAME" "$AMI_ID" "$INSTANCE_TYPE" "$KEY_NAME" "$SUBNET_ID" "$SECURITY_GROUP"

	echo "EC2 instance creation completed...."
}

main "$@"
