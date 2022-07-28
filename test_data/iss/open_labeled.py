import matplotlib.pyplot as plt
from skimage import io
from glob import glob

for file in glob('./*gray_labeled.tif'):
    image = io.imread(file)
    plt.imshow(image)
    plt.show()
