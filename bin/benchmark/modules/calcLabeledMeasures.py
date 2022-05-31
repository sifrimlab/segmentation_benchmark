import numpy as np


def calcIoU(ground_truth_arr: np.ndarray, to_benchmark_arr: np.ndarray ):
    # IoU calculation
    intersection = np.logical_and(ground_truth_arr, to_benchmark_arr)
    union = np.logical_or(ground_truth_arr, to_benchmark_arr)
    iou_score = np.sum(intersection) / np.sum(union)
    
    return iou_score
