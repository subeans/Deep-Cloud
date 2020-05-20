#!/bin/bash
tensorboard --logdir=./logs-16 &

NAME_LIST=$(find ./ -name *.trace.json.gz)

TB_URL1="http://localhost:6006/data/plugin/profile/data?run="
TB_URL3="/train/"
TB_URL5="&tag=tensorflow_stats&host=ip-"
TB_URL7="&tqx=out:csv;"

for NAME in $NAME_LIST
do
        FILENAME="$NAME.csv"
        TB_URL2=$(echo $NAME | cut -d "/" -f 3)
        TB_URL4=$(echo $NAME | cut -d "/" -f 7)
        TB_URL6=$(echo $NAME | cut -d "/" -f 8 | awk -F '[-.]' '{print $2"-"$3"-"$4"-"$5}')
        TB_URL="$TB_URL1$TB_URL2$TB_URL3$TB_URL4$TB_URL5$TB_URL6$TB_URL7"
        echo TB_URL
#        curl -o $FILENAME $TB_URL
done
