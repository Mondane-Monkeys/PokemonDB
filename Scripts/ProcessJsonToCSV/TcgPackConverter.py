import os
import json
import csv
import re

import pandas as pd

# Define the relative path to the JSON file
script_dir = os.path.dirname(os.path.abspath(__file__))
json_file_path= os.path.join(script_dir, "..", "..", "Sources", "pokemon-tcg-data", "sets", "en.json")

def export(input_path, output_dir):
    with open(json_file_path, encoding='utf-8') as f:
        data = json.loads(f.read())
        pokemon_sets= flatten_sets(data)
    df_sets = pd.DataFrame(pokemon_sets)
    df_sets.to_csv(os.path.join(output_dir, 'card_sets.csv'), encoding='utf-8', index=False)


def flatten_sets(sets):
    set_list = []
    for set in sets:
        set_data = {
            "id": set["id"],
            "name": set["name"],
            "series": set["series"],
            "printedTotal": set["printedTotal"],
            "total": set["total"],
            "ptcgoCode": set.get("ptcgoCode", ""),
            "releaseDate": set["releaseDate"],
            "updatedAt": set["updatedAt"],
            "symbol":set["images"]["symbol"],
            "logo":set["images"]["logo"],
            "legalities_unlimited": set.get("legalities", {}).get("unlimited", ""),
            "legalities_expanded": set.get("legalities", {}).get("expanded", ""),
            "legalities_standard": set.get("legalities", {}).get("standard", ""),
        }
        set_list.append(set_data)
    return set_list

if __name__ == "__main__":
    export(json_file_path, os.path.join(script_dir, 'output'))