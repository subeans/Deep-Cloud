from __future__ import absolute_import
from __future__ import division
from __future__ import print_function

from datetime import datetime
from packaging import version

import math
import time
import pickle

import os
import tensorflow as tf

import argparse

parser = argparse.ArgumentParser()
parser.add_argument('--batch_size', default=128, type=int)
parser.add_argument('--prof_start_batch', default=500, type=int)
parser.add_argument('--prof_end_batch', default=520, type=int)

args = parser.parse_args()

device_name = tf.test.gpu_device_name()
if not device_name:
	raise SystemError('GPU Device Not Found')
print('Found GPU at :{}'.format(device_name))

batch_size = args.batch_size
num_classes = 10

num_data = 50000
batch_data = math.ceil(num_data / args.batch_size)
epochs = math.ceil(args.prof_end_batch / batch_data)

# input image dimensions
img_rows, img_cols = 32, 32

# the data, split between train and test sets
(x_train, y_train), (x_test, y_test) = tf.keras.datasets.mnist.load_data()

if tf.keras.backend.image_data_format() == 'channels_first':
    x_train = x_train.reshape(x_train.shape[0], 3, img_rows, img_cols)
    x_test = x_test.reshape(x_test.shape[0], 3, img_rows, img_cols)
    input_shape = (3, img_rows, img_cols)
else:
    x_train = x_train.reshape(x_train.shape[0], img_rows, img_cols, 3)
    x_test = x_test.reshape(x_test.shape[0], img_rows, img_cols, 3)
    input_shape = (img_rows, img_cols, 3)

x_train = x_train.astype('float32')
x_test = x_test.astype('float32')
x_train /= 255
x_test /= 255
print('x_train shape:', x_train.shape)
print(x_train.shape[0], 'train samples')
print(x_test.shape[0], 'test samples')

# convert class vectors to binary class matrices
y_train = tf.keras.utils.to_categorical(y_train, num_classes)
y_test = tf.keras.utils.to_categorical(y_test, num_classes)

def res_block(x,filter,stride,name):
    input = x
    if stride != 1:
        input = tf.keras.layers.Conv2D(filters=filter,kernel_size=1,strides=stride,name=name+'_pooling_conv')(input)
        input = tf.keras.layers.BatchNormalization(name=name+'_pooling_bn')(input)

    x = tf.keras.layers.Conv2D(filters=filter,kernel_size=1,strides=stride,padding='same',name=name+'_conv1')(x)
    x = tf.keras.layers.BatchNormalization(name=name+'_bn1')(x)
    x = tf.nn.relu(x,name=name+'_relu1')

    x = tf.keras.layers.Conv2D(filters=filter,kernel_size=1,strides=1,padding='same',name=name+'_conv2')(x)
    x = tf.keras.layers.BatchNormalization(name=name+'_bn2')(x)
    x = tf.keras.layers.add([input,x],name=name+'_add')

    x = tf.nn.relu(x,name=name+'_relu2')
    return x

def model_builder(x,attention):
    
    x = tf.keras.layers.Conv2D(filters=64,kernel_size=7,strides=2,activation='relu',padding='same',name='conv1')(x)
    x = tf.keras.layers.BatchNormalization(name='conv1_bn')(x)
    x = tf.keras.layers.MaxPool2D(pool_size=3,strides=2,padding='same',name='conv1_max_pool')(x)

    x = res_block(x,64,2,'ResBlock21')
    x = res_block(x,64,1,'ResBlock22')
    x = res_block(x,128,2,'ResBlock31')
    x = res_block(x,128,1,'ResBlock32')

    x =tf.keras.layers.GlobalAveragePooling2D(name='GAP')(x) 
    pred = tf.keras.layers.Dense(num_classes,activation='softmax')(x)
    
    return pred

inputs = tf.keras.Input(shape=(32,32,1))

pred_normal = model_builder(inputs,None)

model = tf.keras.Model(inputs=inputs,outputs=pred_normal)

model.compile(loss=tf.keras.losses.categorical_crossentropy,
              optimizer=tf.keras.optimizers.Adadelta(),
              metrics=['accuracy'])

class BatchTimeCallback(tf.keras.callbacks.Callback):
    def on_train_begin(self, logs=None):
        self.all_times = []

    def on_train_end(self, logs=None):
        time_filename = "/home/ubuntu/Deep-Cloud/tensorstats/times-" + str(args.batch_size) + "-" + datetime.now().strftime("%Y%m%d-%H%M%S") + ".pickle"
        time_file = open(time_filename, 'ab')
        pickle.dump(self.all_times, time_file)
        time_file.close()

    def on_epoch_begin(self, epoch, logs=None):
        self.epoch_times = []

    def on_epoch_end(self, epoch, logs=None):
        self.all_times.append(self.epoch_times)

    def on_train_batch_begin(self, batch, logs=None):
        self.batch_time_start = time.time()

    def on_train_batch_end(self, batch, logs=None):
        self.epoch_times.append(time.time() - self.batch_time_start)

batch_time_callback = BatchTimeCallback()

logs = "/home/ubuntu/Deep-Cloud/logs/"  + str(args.batch_size) + "-" + datetime.now().strftime("%Y%m%d-%H%M%S")
prof_range = str(args.prof_start_batch) + ',' + str(args.prof_end_batch)
tboard_callback = tf.keras.callbacks.TensorBoard(log_dir = logs,
                                                 histogram_freq = 1,
                                                 profile_batch = prof_range)

model.fit(x_train, y_train,
          batch_size=batch_size,
          epochs=epochs,
          verbose=1,
          validation_data=(x_test, y_test),
          callbacks = [tboard_callback])
