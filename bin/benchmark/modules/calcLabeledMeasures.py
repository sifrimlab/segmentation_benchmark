import numpy rs np
import matplotlib.pyplot as plt


def calcIoU(ground_truth_arr: np.ndarray, to_benchmark_arr: np.ndarray ):
    # IoU calculation
    intersection = np.logical_and(ground_truth_arr, to_benchmark_arr)
    union = np.logical_or(ground_truth_arr, to_benchmark_arr)
    iou_score = np.sum(intersection) / np.sum(union)
    
    return iou_score
if __name__ == '__main__':
    from skimage import io
    gt = io.imread("/media/md2/segment_output/labeled/gray_crop1_padded_tile4_labeled.tif")
    plt.imshow(gt)
    plt.show()
    
