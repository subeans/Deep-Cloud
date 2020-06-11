#!bin/bash
# Get Instance Type
JOB_NAME=$1

# Get profile result at half of 2epoch
sudo time -i -u root bash << EOF

python3.6 /home/ubuntu/Deep-Cloud/job/$JOB_NAME --batch_size 128 --prof_start_batch 702 --prof_end_batch 703
sleep 3

EOF
