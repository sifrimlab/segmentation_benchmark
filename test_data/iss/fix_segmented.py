from skimage import io
from skimage.color import rgb2gray
from skimage.measure import label
from PIL import Image
import matplotlib.pyplot as plt
import numpy as np
Image.MAX_IMAGE_PIXELS = 1000000000

"""
bg:
1 = 50
2 = 4
3 = 150
"""

bgs = {1:197, 2:147, 3:150}
index = 2
file = f"segmented{index}_gray"
segmented = io.imread(f"{file}.tif")
# segmented = io.imread(f"./{file}_gray.png")
# segmented = rgb2gray(segmented)
# io.imsave("./segmented1_gray.png", segmented)

# values, counts = np.unique(segmented, return_counts=True)
# ind = np.argmax(counts)
# bg_val = values[ind]

segmented = label(segmented,background = bgs[index])
# plt.imshow(segmented)
# plt.show()

io.imsave(f"{file}_labeled.tif", segmented)





