#!/bin/bash

# Based on AWS DeepLearning AMI with Ubuntu 18.04
sudo bash

# Set the CUDA Version as 10.1
# TensorFlow Profiler and CUPTI Doesn't Work on CUDA 10.2
# At 2020. 05. 03
rm /usr/local/cuda
ln -s /usr/local/cuda-10.1 /usr/local/cuda

# Upgrade pip3 and install tensorflow, tensorboard, dataset packages
pip3 install --upgrade pip
pip3 install tf-nightly 
pip3 install tb-nightly 
pip3 install tensorboard_plugin_profile
pip3 install tensorflow_datasets

mkdir img_clf
cd img_clf
