#!/bin/bash
# Since: November, 2019
# Author: jordy@adobe.com

# Description: 
#    - Start docker acc_standalone

# docker run --platform linux/amd64 -d -p 80:80 -p 8080:8080 -p 443:443 -it --name=acc_standalone acc_standalone:latest 
docker-compose up -d

docker ps -a 