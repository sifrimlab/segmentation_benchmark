import pandas as pd
import re

def extractNumber(string, prefix):
    return re.findall(r'\d+', (re.findall(rf'{prefix}\d+', string)[0]))[0] 


def parseConcatCSV(path):
    df = pd.read_csv(path)
    try: 
        df["tile"] = df.apply (lambda row: extractNumber(row, "tile"), axis=1)
    except:
        pass
    df["image_nr"] = df.apply (lambda row: extractNumber(row["name"], "nuclei"), axis=1)

    print(df.groupby('method').mean())
    print(df.groupby('image_nr').mean())

if __name__ == '__main__':
    parseConcatCSV("./concat_all_IoU_measures.csv")
