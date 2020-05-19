#!/bin/bash

aws ec2 run-instances --image-id ami-abcd1234 --count 1 --instance-type m3.medium \
--key-name my-key-pair --subnet-id subnet-abcd1234 --security-group-ids sg-abcd1234 \
--user-data file://user_script.txt

sleep 30
INSTANCE_ID=$(echo $INSTANCE_INFO | jq -r '. | .Instances[0].InstanceId')
INSTANCE_PUB_DNS=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID | jq -r '. | .Reservations[0].Instances[0].PublicDnsName')
echo $INSTANCE_PUB_DNS

sleep 30
echo 'clone start'
ssh -o "StrictHostKeyChecking no" -i awspwd.pem uvuntu@$INSTANCE_PUB_DNS 'git clone https://github.com/odobenuskr/Deep-Cloud.git;cd Deep-Cloud'
echo 'setting start'
ssh -i awspwd.pem uvuntu@$INSTANCE_PUB_DNS 'bash ./settings.sh'
echo 'run start'
ssh -i awspwd.pem uvuntu@$INSTANCE_PUB_DNS 'bash ./run.sh'
