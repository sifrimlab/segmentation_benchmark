import numpy as np
from skimage import io
from csbdeep.utils import Path, normalize
from stardist.models import StarDist2D

def stardistSegment(img: np.array, model:str = "2D_versatile_fluo") -> np.array:
    """Segments cells using pretrained stardist models.

    Parameters
    ----------
    img : np.array
        image to be segmented
    model : str
        String representing which pretrained stardist model to load. Choose one of: (2D_versatile_fluo, 2D_versatile_he, 2D_paper_dsb2018)

    Returns
    -------
    np.array

    """
    model_versatile = StarDist2D.from_pretrained(model)

    # extract number of channels in case the input image is an RGB image
    n_channel = 1 if img.ndim == 2 else img.shape[-1]
    # depending on that, we want to normalize the channels independantly
    axis_norm = (0,1)   # normalize channels independently
    # axis_norm = (0,1,2) # normalize channels jointly

    img_normalized = normalize(img, 1,99.8, axis=axis_norm)

    labeled_image, details = model_versatile.predict_instances(img_normalized)
    return labeled_image 

if __name__ == '__main__':
    import sys
    dapi_path = sys.argv[1]
    dapi_img = io.imread(dapi_path)
    prefix =  sys.argv[2]
    labeled_image = stardistSegment(dapi_img)
    io.imsave(f"{prefix}_labeled.tif", labeled_image)

