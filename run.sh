# batch size 를 for 문으로 돌면서 작동
# time_list 의 naming 은 profile2.py python 내부에서 처리하도록 함
# 

# Batch 16
python3.6 profile.py --batch_size 16 --prof_start_batch 1 --prof_end_batch 2
sleep 5
python3.6 profile.py --batch_size 16 --prof_start_batch 5001 --prof_end_batch 5002
sleep 5
python3.6 profile.py --batch_size 16 --prof_start_batch 10001 --prof_end_batch 10002
sleep 5
python3.6 profile.py --batch_size 16 --prof_start_batch 50001 --prof_end_batch 50002
sleep 5
python3.6 profile.py --batch_size 16 --prof_start_batch 100001 --prof_end_batch 100002
sleep 5
python3.6 profile.py --batch_size 16 --prof_start_batch 200001 --prof_end_batch 200002
sleep 5

python3.6 profile2.py --batch_size 16 --prof_start_batch 200001 --prof_end_batch 200002
sleep 5
mv time_list ./mnist-lenet5-g3.4xlarge-16-200001iter-latency.pickle
sleep 5

# Batch 32
python3.6 profile.py --batch_size 32 --prof_start_batch 1 --prof_end_batch 2
sleep 5
python3.6 profile.py --batch_size 32 --prof_start_batch 2001 --prof_end_batch 2002
sleep 5
python3.6 profile.py --batch_size 32 --prof_start_batch 5001 --prof_end_batch 5002
sleep 5
python3.6 profile.py --batch_size 32 --prof_start_batch 10001 --prof_end_batch 10002
sleep 5
python3.6 profile.py --batch_size 32 --prof_start_batch 50001 --prof_end_batch 50002
sleep 5
python3.6 profile.py --batch_size 32 --prof_start_batch 100001 --prof_end_batch 100002
sleep 5

python3.6 profile2.py --batch_size 32 --prof_start_batch 100001 --prof_end_batch 100002
sleep 5
mv time_list ./mnist-lenet5-g3.4xlarge-32-100001iter-latency.pickle
sleep 5

# Batch 64
python3.6 profile.py --batch_size 64 --prof_start_batch 1 --prof_end_batch 2
sleep 5
python3.6 profile.py --batch_size 64 --prof_start_batch 1001 --prof_end_batch 1002
sleep 5
python3.6 profile.py --batch_size 64 --prof_start_batch 2001 --prof_end_batch 2002
sleep 5
python3.6 profile.py --batch_size 64 --prof_start_batch 5001 --prof_end_batch 5002
sleep 5
python3.6 profile.py --batch_size 64 --prof_start_batch 10001 --prof_end_batch 10002
sleep 5
python3.6 profile.py --batch_size 64 --prof_start_batch 50001 --prof_end_batch 50002
sleep 5

python3.6 profile2.py --batch_size 64 --prof_start_batch 50001 --prof_end_batch 50002
sleep 5
mv time_list ./mnist-lenet5-g3.4xlarge-64-50001iter-latency.pickle
sleep 5

# Batch 128
python3.6 profile.py --batch_size 128 --prof_start_batch 1 --prof_end_batch 2
sleep 5
python3.6 profile.py --batch_size 128 --prof_start_batch 501 --prof_end_batch 502
sleep 5
python3.6 profile.py --batch_size 128 --prof_start_batch 1001 --prof_end_batch 1002
sleep 5
python3.6 profile.py --batch_size 128 --prof_start_batch 2001 --prof_end_batch 2002
sleep 5
python3.6 profile.py --batch_size 128 --prof_start_batch 5001 --prof_end_batch 5002
sleep 5
python3.6 profile.py --batch_size 128 --prof_start_batch 10001 --prof_end_batch 10002
sleep 5

python3.6 profile2.py --batch_size 128 --prof_start_batch 10001 --prof_end_batch 10002
sleep 5
mv time_list ./mnist-lenet5-g3.4xlarge-128-10001iter-latency.pickle
sleep 5

# Batch 256
python3.6 profile.py --batch_size 256 --prof_start_batch 1 --prof_end_batch 2
sleep 5
python3.6 profile.py --batch_size 256 --prof_start_batch 251 --prof_end_batch 252
sleep 5
python3.6 profile.py --batch_size 256 --prof_start_batch 1001 --prof_end_batch 1002
sleep 5
python3.6 profile.py --batch_size 256 --prof_start_batch 2001 --prof_end_batch 2002
sleep 5
python3.6 profile.py --batch_size 256 --prof_start_batch 5001 --prof_end_batch 5002
sleep 5
python3.6 profile.py --batch_size 256 --prof_start_batch 10001 --prof_end_batch 10002
sleep 5

python3.6 profile2.py --batch_size 256 --prof_start_batch 10001 --prof_end_batch 10002
sleep 5
mv time_list ./mnist-lenet5-g3.4xlarge-256-5001iter-latency.pickle
sleep 5
