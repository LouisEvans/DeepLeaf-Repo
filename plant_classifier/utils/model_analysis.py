import matplotlib.pyplot as plt

# A simple utility to create a plot

# X-axis
epochs = [1, 2, 3, 4]

# Lines
loss_final = [
    3.3412,
    2.3884,
    2.0833,
    1.9012
]
loss_mvp = [
    3.5781,
    2.5970,
    2.2483,
    3.6
]

# Display plots
plt.plot(epochs, loss_final, label="Final Loss")
plt.plot(epochs, loss_mvp, label="MVP Loss")

plt.title('Categorial Cross Entropy Loss, MVP vs Final Model')
plt.legend(loc="upper left")
plt.show()
