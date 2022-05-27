import sys
import pandas as pd
from skimage import io
import numpy as np

def collectMeasures(measures_csv_list: str):
    """
    The idea here is to concat all labels of different tiles, and give them a unique label number, 
    because this will not be the case if analysis is done seperately
    """
    df_list = [pd.read_csv(csv) for csv in property_csv_list]
    total_df = pd.concat(df_list)
    total_df = total_df.sort_values(by=['name'])
    # new_index = list(range(1,len(total_df)+1))
    return total_df

if __name__ == "__main__":
    properties = [sys.argv[i] for i in range(1,len(sys.argv))]
    concat_df = collectMeasures(properties)
    concat_df.to_csv(f"concat_measures.csv", index=False) 




