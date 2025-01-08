from __future__ import absolute_import, division, print_function, unicode_literals

#tensorflow and keras
import tensorflow as tf
from tensorflow import keras

#helper libraries
import numpy as np
import matplotlib.pyplot as plt

print(tf.__version__)

fashionmnist = keras.datasets.fashion_mnist
(trian_images, train_labels), (test_images, test_labels) = fashionmnist.load_data