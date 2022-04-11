import sys
import pandas as pd
from skimage import io
import numpy as np

def collectProperties(property_csv_list: str):
    """
    The idea here is to concat all labels of different tiles, and give them a unique label number, 
    because this will not be the case if analysis is done seperately
    """
    df_list = [pd.read_csv(csv) for csv in property_csv_list]
    total_df = pd.concat(df_list)
    total_df = total_df.sort_values(by=['Tile'])
    new_index = list(range(1,len(total_df)+1))
    total_df['Label'] = new_index
    return total_df

if __name__ == "__main__":
    properties = [sys.argv[i] for i in range(1,len(sys.argv))]
    concat_df = collectProperties(properties)
    concat_df.to_csv(f"concat_segmented_properties.csv", index=False) 



