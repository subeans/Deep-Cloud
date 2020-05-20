#!/bin/bash
tensorboard --logdir=./logs

TB_URL1="http://localhost:6006/data/plugin/profile/data?run="
TB_URL2="20200514-105804"
TB_URL3="/train/"
TB_URL4="2020_05_14_10_58_22"
TB_URL5="&tag=tensorflow_stats&host=ip-172-31-20-125&tqx=out:csv;"
TB_URL="$TB_URL1$TB_URL2$TB_URL3$TB_URL4$TB_URL5"

for FILENAME in 
do
        curl -o $FILENAME $TB_URL
done
