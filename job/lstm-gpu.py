'''
#Trains an LSTM model on the IMDB sentiment classification task.

The dataset is actually too small for LSTM to be of any advantage
compared to simpler, much faster methods such as TF-IDF + LogReg.

**Notes**

- RNNs are tricky. Choice of batch size is important,
choice of loss and optimizer is critical, etc.
Some configurations won't converge.

- LSTM loss decrease patterns during training can be quite different
from what you see with CNNs/MLPs/etc.

'''
from __future__ import absolute_import
from __future__ import division
from __future__ import print_function

import tensorflow as tf
from datetime import datetime
from packaging import version

from tf.keras.preprocessing import sequence
from tf.keras.models import Sequential
from tf.keras.layers import Dense, Embedding
from tf.keras.layers import LSTM
from tf.keras.datasets import imdb

import time
import os
import argparse

time_start = time.perf_counter()

device_name = tf.test.gpu_device_name()
if not device_name:
	raise SystemError('GPU Device Not Found')
print('Found GPU at :{}'.format(device_name))

parser = argparse.ArgumentParser()
parser.add_argument('--batch_size', default=128, type=int)
parser.add_argument('--prof_start_batch', default=500, type=int)
parser.add_argument('--prof_end_batch', default=520, type=int)
args = parser.parse_args()

max_features = 20000
# cut texts after this number of words (among top max_features most common words)
maxlen = 80
batch_size = args.batch_size
epochs = 30

print('Loading data...')
(x_train, y_train), (x_test, y_test) = imdb.load_data(num_words=max_features)
print(len(x_train), 'train sequences')
print(len(x_test), 'test sequences')

print('Pad sequences (samples x time)')
x_train = sequence.pad_sequences(x_train, maxlen=maxlen)
x_test = sequence.pad_sequences(x_test, maxlen=maxlen)
print('x_train shape:', x_train.shape)
print('x_test shape:', x_test.shape)

print('Build model...')
model = Sequential()
model.add(Embedding(max_features, 128))
model.add(LSTM(128, dropout=0.2, recurrent_dropout=0.2))
model.add(Dense(1, activation='sigmoid'))

# try using different optimizers and different optimizer configs
model.compile(loss='binary_crossentropy',
              optimizer='adam',
              metrics=['accuracy'])

print('Train...')
model.fit(x_train, y_train,
          batch_size=batch_size,
          epochs=epochs,
          validation_data=(x_test, y_test))
score, acc = model.evaluate(x_test, y_test,
                            batch_size=batch_size)
print('Test score:', score)
print('Test accuracy:', acc)

time_end = time.perf_counter()
time_taken = time_end-time_start
print("runtime: %.4f sec" % (time_taken))
