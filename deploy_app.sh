#!/bin/bash

<<comment
task is to deploy django app

comment

clone_app(){
  	echo "clonning the django app"
	git clone https://github.com/LondheShubham153/django-notes-app.git

}

install_requirements(){
       echo "installment started"
       sudo apt-get install docker.io nginx -y

}

required_restart(){
      sudo chown $USER /var/run/docker.sock
      sudo systemctl enable docker
      sudo systemctl enable nginx
      sudo systemctl restart docker
}

deploy_app(){
       docker build -t notes-app .
       docker run -d -p 8000:8000 notes-app:latest
}


echo "********DEPLOYMENT STARTED**********"

if ! clone_app; then
	echo "the Directory is already exists"
	cd django-notes-app
fi

if ! install_requirements; then
	echo "installtion failed "
	exit 1
fi

if ! required_restart; then
	echo "System fault identified"
	exit 1
fi

if ! deploy_app; then 
	echo "deployment failed, mainling the admin"
	# sendmail
fi 


echo "**********DEPLOYMENT DONE********"
