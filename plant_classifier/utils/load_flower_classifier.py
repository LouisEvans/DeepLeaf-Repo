import tensorflow as tf
from PIL import Image
import numpy as np
from skimage import transform

# Used to load a binary classifier.
# In this case, the flower classifier

# Set memory growth to true for all GPUs (bugfix)
gpus = tf.config.experimental.list_physical_devices('GPU')
if gpus:
    try:
        for gpu in gpus:
            tf.config.experimental.set_memory_growth(gpu, True)
        logical_gpus = tf.config.experimental.list_logical_devices('GPU')
        print(len(gpus), "Physical GPUs,", len(logical_gpus), "Logical GPUs")
    except RuntimeError as e:
        print(e)

# Declare class labels
classes = ['false', 'true']

# Load model
model = tf.keras.models.load_model("my_model6")

# Open image and resize
img = Image.open(
    r"F:/Users/Customer/Desktop/Computer Science Uni/_Final year dissertation/plantnet_300K/images_train_resized/1355961/f821156ae4e1992817a4147c17db18d697ec8adf.jpg")
img = np.array(img).astype('float32')/255
img = transform.resize(img, (200, 200, 3))
img = np.expand_dims(img, axis=0)

# Make prediction
prediction = model.predict(img)

# Extract label
v, i = tf.nn.top_k(prediction, k=1)
p_value = v.numpy()[0][0]
p_index = i.numpy()[0][0]
p_plant = classes[p_index]

# Return prediction
print("Prediction: "+p_plant+", with a confidence of "+str(p_value))
