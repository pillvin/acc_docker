#!/bin/bash
# Since: November, 2019
# Author: jordy@adobe.com

# Description: 
#    - Build Docker acc_standalone

docker build -f ./Dockerfile --platform linux/amd64 -t acc_standalone .