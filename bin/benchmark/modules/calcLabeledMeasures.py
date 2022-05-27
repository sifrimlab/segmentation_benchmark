import numpy as np


def calcIoU(ground_truth_arr: np.ndarray, to_benchmark_arr: np.ndarray ):
    # IoU calculation
    intersection = numpy.logical_and(ground_truth_arr, to_benchmark_arr)
    union = numpy.logical_or(ground_truth_arr, to_benchmark_arr)
    iou_score = numpy.sum(intersection) / numpy.sum(union)
    
    return iou_score
