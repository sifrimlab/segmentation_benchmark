from skimage import io
import numpy as np


file = "./crop3.tif"
image = io.imread(file)
x_diff =  19500 - 14748
y_diff =  19500 - 14720
x_start =int(  x_diff / 2 ) 
y_start =int(  y_diff / 2 ) 
x_end =int( 19500 - (x_diff / 2) ) 
y_end =int(   19500 - (y_diff  / 2))
image =  image[y_start:y_end, x_start:x_end]

io.imsave(file, image)


