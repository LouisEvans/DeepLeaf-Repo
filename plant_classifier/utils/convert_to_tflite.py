import tensorflow as tf

# Used to convert a saved model to TFLite,
# for use in a mobile app

# Declare saved model origin directory
origin = r"F:/Users/Customer/Desktop/Computer Science Uni/_Final year dissertation/PlantIdentifier/checkpoints_final_final"

# Make converter
converter = tf.lite.TFLiteConverter.from_saved_model(
    origin)

# Convert
tflite_model = converter.convert()

# Save
save_dir = 'finalmodel.tflite'
with open(save_dir, 'wb') as f:
    f.write(tflite_model)
