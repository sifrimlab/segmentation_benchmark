import os
import sys
import pandas as pd
from modules.calcLabeledMeasures import calcIoU
from skimage import io

labeled_image = io.imread(sys.argv[1])
ground_truth = io.imread(sys.argv[2])
prefix = os.path.splitext(sys.argv[2])[0]
method = sys.argv[3]
iou = calcIoU(ground_truth, labeled_image)

df = pd.DataFrame({"name": prefix,"method": method, "IoU": iou}, index = [0])
df.to_csv(f"{prefix}_IoU.csv", index=False)


