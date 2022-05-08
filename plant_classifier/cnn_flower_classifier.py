from keras.layers import Flatten, Dense
from tensorflow.keras import Model
from tensorflow.keras import applications, optimizers, backend as K
from tensorflow.keras.preprocessing.image import ImageDataGenerator
from tensorflow.keras.applications.resnet50 import ResNet50
from tensorflow.keras.models import Sequential, Model
import tensorflow.keras.metrics as metrics
import matplotlib.pyplot as plt
import tensorflow as tf

# The Flower classifier. Decides whether a flower is in an image or not

# Set memory growth for all GPUs
print("Num GPUs Available: ", len(tf.config.list_physical_devices('GPU')))
physical_devices = tf.config.experimental.list_physical_devices('GPU')
assert len(physical_devices) > 0, "Not enough GPU hardware devices available"
config = tf.config.experimental.set_memory_growth(physical_devices[0], True)

# Create base ResNet50 model with imagenet weights
base_model = applications.ResNet50(
    weights='imagenet', include_top=False, input_shape=(200, 200, 3))

# Add extra layers
add_model = Sequential()
add_model.add(Flatten(input_shape=base_model.output_shape[1:]))
add_model.add(Dense(64, activation='relu'))
add_model.add(Dense(2, activation='softmax'))

# Combine base model and my fully connected layers
model = Model(inputs=base_model.input,
              outputs=add_model(base_model.output))

# Specify SGD optimizer parameters
sgd = optimizers.SGD(lr=0.001, decay=1e-6, momentum=0.9, nesterov=True)

# Compile model
model.compile(loss='categorical_crossentropy',
              optimizer=sgd,
              metrics=['accuracy', metrics.TopKCategoricalAccuracy(k=5)])

print("Model created successfully!")

model.summary()

# --------------------

# Rescale all images to 1./255
# Augment
train_datagen = ImageDataGenerator(rescale=1./255, rotation_range=40,
                                   width_shift_range=0.2,
                                   height_shift_range=0.2,
                                   shear_range=0.2,
                                   zoom_range=0.2,
                                   horizontal_flip=True,)
val_datagen = ImageDataGenerator(rescale=1./255)

# Create dataset generators and specify loss function
train_dir = r"F:\Users\Customer\Desktop\Computer Science Uni\_Final year dissertation\plantnet_300K\flower_dataset\train"
train_generator = train_datagen.flow_from_directory(
    train_dir, target_size=(200, 200), batch_size=6, class_mode="categorical")
val_dir = r"F:\Users\Customer\Desktop\Computer Science Uni\_Final year dissertation\plantnet_300K\flower_dataset\val"
validation_generator = val_datagen.flow_from_directory(
    val_dir, target_size=(200, 200), batch_size=6, class_mode="categorical")

# Create callback to save model every epoch
model_callback = tf.keras.callbacks.ModelCheckpoint(
    filepath=r"F:/Users/Customer/Desktop/Computer Science Uni/_Final year dissertation/PlantIdentifier/checkpoints_flower",
    verbose=1,
    save_weights_only=False,
    save_freq='epoch')

# Run training
history = model.fit_generator(
    train_generator,
    steps_per_epoch=340,  # 40245
    epochs=3,  # 8
    validation_data=validation_generator,
    validation_steps=119,  # 5184
    verbose=2,
    callbacks=[model_callback])

print("Completed")

model.save('my_model6')

# Get accuracy
acc = history.history['accuracy']
val_acc = history.history['val_accuracy']

# Get loss
loss = history.history['loss']
val_loss = history.history['val_loss']

# Get number of epochs
epochs = range(len(acc))

# Plot training and validation accuracy per epoch
plt.plot(epochs, acc, label="Training")
plt.plot(epochs, val_acc, label="Validation")
plt.title('Training and validation accuracy')
plt.legend(loc="upper left")

plt.figure()

# Plot training and validation loss per epoch
plt.plot(epochs, loss, label="Training")
plt.plot(epochs, val_loss, label="Validation")
plt.title('Training and validation loss')
plt.legend(loc="upper left")
plt.show()
