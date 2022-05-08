import os

# A tool to check which directories exist in one directory
# but not the other

f1 = r"F:/Users/Customer/Desktop/Computer Science Uni/_Final year dissertation/plantnet_300K/flower_grabcut_dataset/train"
f2 = r"F:/Users/Customer/Desktop/Computer Science Uni/_Final year dissertation/plantnet_300K/flower_grabcut_dataset/val"

# For each folder in f2
for i in os.scandir(f2):

    # Get class label
    classification_dir = os.path.basename(
        os.path.normpath(i.path))

    # If not in f1, print
    if not os.path.isdir(f1 + "/" + classification_dir):
        print(i)
