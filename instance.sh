#!/bin/bash

aws ec2 run-instances --image-id ami-abcd1234 --count 1 --instance-type m3.medium \
--key-name my-key-pair --subnet-id subnet-abcd1234 --security-group-ids sg-abcd1234 \
--user-data file://user_script.txt

INSTANCE_ID=$(echo $START_LOG | jq -r '. | .Instances[0].InstanceId')
echo $INSTANCE_ID