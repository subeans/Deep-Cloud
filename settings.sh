#!/bin/bash

# Based on AWS DeepLearning AMI with Ubuntu 18.04

# Set the CUDA Version as 10.1
# TensorFlow Profiler and CUPTI Doesn't Work on CUDA 10.2
# At 2020. 05. 03
sudo rm /usr/local/cuda
sudo ln -s /usr/local/cuda-10.1 /usr/local/cuda

# Upgrade pip3 and install tensorflow, tensorboard, dataset packages
sudo pip3 install --upgrade pip
sudo pip3 install tf-nightly 
sudo pip3 install tb-nightly 
sudo pip3 install tensorboard_plugin_profile
sudo pip3 install tensorflow_datasets
