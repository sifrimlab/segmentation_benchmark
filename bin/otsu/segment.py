import cv2
import matplotlib.pyplot as plt
import numpy as np
from skimage import measure
from skimage.util import img_as_ubyte

def otsuSegment(img: np.array) -> np.array :
    '''
        note to self: this code adapted from DigitalSreeni assumes that your input image is an 8-bit rgb, which makes it so that we have to do some image format transformation because:
        - cv2.shreshold accepts only 8-bit grayscale
        - cv2.watershed only accepts 8-bit rgb
    '''
    '''
    returns a labeled image, where 0 = background and all other integers an object number.
    These numbers don't have any actual image value, so the image isn't really used as an image object, but more as an array
    that stores which pixel belongs to which label. Also returns a csv that contains image properties of the given objects
    '''
    # Create an 8bit version of the image
    img_as_8 = img_as_ubyte(img)
    # Creat an RGB version that only has signal in the blue channel
    shape = img_as_8.shape
    empty = np.zeros(shape)
    img_as_8bit_RGB = cv2.merge([img_as_8,img_as_8,img_as_8])
    try:
        cells = img[:,:,0]
    except IndexError:
        cells = img_as_8

    ret1, thresh = cv2.threshold(cells, 0, 255, cv2.THRESH_BINARY+cv2.THRESH_OTSU)

    # Morphological operations to remove small noise - opening
    #To remove holes we can use closing
    kernel = np.ones((3,3),np.uint16)
    opening = cv2.morphologyEx(thresh,cv2.MORPH_OPEN,kernel, iterations = 2)

    # from skimage.segmentation import clear_border
    # opening = clear_border(opening) #Remove edge touching grains

    sure_bg = cv2.dilate(opening,kernel,iterations=10)
    dist_transform = cv2.distanceTransform(opening,cv2.DIST_L2,5)
    ret2, sure_fg = cv2.threshold(dist_transform,0.5*dist_transform.max(),255,0)

    #Later you realize that 0.25* max value will not separate the cells well.
    #High value like 0.7 will not recognize some cells. 0.5 seems to be a good compromize

    # Unknown ambiguous region is nothing but bkground - foreground
    sure_fg = np.uint8(sure_fg)
    unknown = cv2.subtract(sure_bg,sure_fg)

    #Now we create a marker and label the regions inside.
    # For sure regions, both foreground and background will be labeled with positive numbers.
    # Unknown regions will be labeled 0.
    #For markers let us use ConnectedComponents.
    ret3, markers = cv2.connectedComponents(sure_fg)

    #One problem rightnow is that the entire background pixels is given value 0.
    #This means watershed considers this region as unknown.
    #So let us add 10 to all labels so that sure background is not 0, but 10
    markers = markers+10

    # Now, mark the region of unknown with zero
    markers[unknown==255] = 0

    #Now we are ready for watershed filling.
    markers = cv2.watershed(img_as_8bit_RGB,markers)
        #The boundary region will be marked -1
    markers[markers==-1] = 10 # add the boundary images to the background

    label_image = measure.label(markers, background=10)
    return label_image

if __name__ == '__main__':
    import sys
    from skimage import io
    dapi_path = sys.argv[1]
    dapi_img = io.imread(dapi_path)
    prefix =  sys.argv[2]
    labeled_image = otsuSegment(dapi_img)
    # io.imsave(f"{prefix}_labeled.tif", labeled_image)
    cv2.imwrite(f"{prefix}_labeled.tif", labeled_image)
