from tensorflow.keras import layers
from tensorflow.keras import Model
from tensorflow.keras.optimizers import Adamax
from tensorflow.keras.preprocessing.image import ImageDataGenerator
from tensorflow.keras.preprocessing.image import img_to_array, load_img
import matplotlib.pyplot as plt

# The original CNN, used as the first model

# Input feature map, 200x200, RGB
img_input = layers.Input(shape=(600, 600, 3))

# First convolution, 16 filters, 3x3, then max-pooling 2x2
x = layers.Conv2D(16, 3, activation="relu")(img_input)
x = layers.MaxPooling2D(2)(x)

# Second convolution, 32 filters, 3x3, then max-pooling 2x2
x = layers.Conv2D(32, 3, activation="relu")(x)
x = layers.MaxPooling2D(2)(x)

# Third convolution, 64 filters, 3x3, then max-pooling 2x2
x = layers.Conv2D(64, 3, activation="relu")(x)
x = layers.MaxPooling2D(2)(x)

# Flatten feature map to 1 dimension
x = layers.Flatten()(x)

# Fully connected layer, ReLU activation, 512 hidden units
x = layers.Dense(512, activation="relu")(x)

# Dropout rate of 0.5
x = layers.Dropout(0.5)(x)

# Output layer with 5 nodes and softmax activation
output = layers.Dense(5, activation="softmax")(x)

# Model
model = Model(img_input, output)

# Compile
model.compile(loss="categorical_crossentropy",
              #   optimizer=RMSprop(lr=0.001),
              optimizer=Adamax(),
              metrics=["acc"])

print("Model created successfully!")

model.summary()

# --------------------

# Augment
train_datagen = ImageDataGenerator(rescale=1./255, rotation_range=40,
                                   width_shift_range=0.2,
                                   height_shift_range=0.2,
                                   shear_range=0.2,
                                   zoom_range=0.2,
                                   horizontal_flip=True,)
val_datagen = ImageDataGenerator(rescale=1./255)

# Create dataset generators and specify loss function
train_dir = r"F:\Users\Customer\Desktop\Computer Science Uni\_Final year dissertation\plantnet_300K\test_train"
train_generator = train_datagen.flow_from_directory(
    train_dir, target_size=(600, 600), batch_size=25, class_mode="categorical")
val_dir = r"F:\Users\Customer\Desktop\Computer Science Uni\_Final year dissertation\plantnet_300K\test_test"
validation_generator = val_datagen.flow_from_directory(
    val_dir, target_size=(600, 600), batch_size=15, class_mode="categorical")

# Run training
history = model.fit_generator(
    train_generator,
    steps_per_epoch=426,  # num of images = batch_size * steps
    epochs=3,
    validation_data=validation_generator,
    validation_steps=89,  # num of images = batch_size * steps
    verbose=2)

# Save
print("Completed")
model.save('my_model1')

# Get accuracy
acc = history.history['acc']
val_acc = history.history['val_acc']

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
