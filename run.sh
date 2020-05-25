# Get Instance Type
INSTANCE_TYPE=$1

# Get profile result at half of 2epoch
for BATCH_SIZE in 64 # 16 32 64 128 256 512
do
        DATA_SIZE=60000
        BATCH_IDX_START=$((($DATA_SIZE/$BATCH_SIZE)*3/2))
        BATCH_IDX_END=$(($BATCH_IDX_START+1))
        echo $BATCH_IDX_START
        echo $BATCH_IDX_END
        python3.6 profile.py --batch_size $BATCH_SIZE \
        --prof_start_batch $BATCH_IDX_START --prof_end_batch $BATCH_IDX_END
done
