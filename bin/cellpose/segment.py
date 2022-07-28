import numpy as np
from cellpose import models

def cellPoseSegment(img: np.array, model:str = "nuclei", channels: np.array = [0,0]) -> np.array:
    """Segments cells using pretrained Cellpose models. Can do both cytoplasm and nuclei at the same time.

    Parameters
    ----------
    img : np.array
        img
    model : str
        String representing which model to use. Either 'nuclei', 'cyto'
    channels : np.array
        Array depicting which channel is either nucleus or DAPI, default = [0,0] -> grayscale for all images
        How to indicate:

        Grayscale=0, R=1, G=2, B=3
        channels = [cytoplasm, nucleus]
        if NUCLEUS channel does not exist, set the second channel to 0
        IF ALL YOUR IMAGES ARE THE SAME TYPE, you can give a list with 2 elements
        channels = [0,0] # IF YOU HAVE GRAYSCALE
        channels = [2,3] # IF YOU HAVE G=cytoplasm and B=nucleus
        channels = [2,1] # IF YOU HAVE G=cytoplasm and R=nucleus
        If they have different orders -> make it a 2D array, e.g: 3 images:
        channels = [[2,3], [1,2], [3,1]]

    Returns
    -------
    np.array

    """
    # model_type='cyto' or model_type='nuclei'
    model = models.Cellpose(gpu=False, model_type=model)
    masks, flows, styles, diams = model.eval(img, diameter=None, channels=channels)
    return masks

if __name__ == '__main__':
    import sys
    from skimage import io
    dapi_path = sys.argv[1]
    dapi_img = io.imread(dapi_path)
    prefix =  sys.argv[2]
    model_str = sys.argv[3]
    labeled_image = cellPoseSegment(dapi_img,model_str)
    io.imsave(f"{prefix}_labeled.tif", labeled_image)




