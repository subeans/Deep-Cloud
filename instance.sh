#!/bin/bash

INSTANCE_TYPE=$1
LAUNCH_INFO=$(aws ec2 run-instances --image-id ami-abcd1234 --count 1 --instance-type $INSTANCE_TYPE \
--key-name my-key-pair --subnet-id subnet-abcd1234 --security-group-ids sg-abcd1234)

sleep 30
INSTANCE_ID=$(echo $LAUNCH_INFO | jq -r '. | .Instances[0].InstanceId')
INSTANCE_PUB_DNS=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID | jq -r '. | .Reservations[0].Instances[0].PublicDnsName')
echo $INSTANCE_PUB_DNS
# Start Settings
sleep 30
echo 'clone start'
ssh -o "StrictHostKeyChecking no" -i awspwd.pem ubuntu@$INSTANCE_PUB_DNS 'git clone https://github.com/odobenuskr/Deep-Cloud.git'
echo 'setting start'
ssh -i awspwd.pem ubuntu@$INSTANCE_PUB_DNS 'cd Deep-Cloud;sudo bash ./settings.sh'

# Run Experiments
sleep 10
echo 'run start'
BASE_COMMAND="cd Deep-Cloud;sudo bash ./run.sh "
RUN_COMMAND="$BASE_COMMAND$INSTANCE_TYPE"
ssh -i awspwd.pem ubuntu@$INSTANCE_PUB_DNS $RUN_COMMAND

# Run Tensorboard backgroound
sleep 10

# Terminate Instance
TERMINATE_INFO=$(aws ec2 terminate-instances --instance-ids $INSTANCE_ID)
echo $TERMINATE_INFO
