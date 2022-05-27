import os
import sys
import pandas as pd
from modules.calcLabeledMeasures import calcIoU
from skimage import io

ground_truth = io.imread(sys.argv[1])
labeled_image = io.imread(sys.argv[2])
prefix = os.path.splitext(ground_truth)[0]
iou = calcIoU(ground_truth, labeled_image)

df = pd.DataFrame({"name": prefix, "IoU": iou})
df.to_csv(f"{prefix}_IoU.csv")


