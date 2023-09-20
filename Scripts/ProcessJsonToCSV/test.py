import os
import json
import csv

# Get the directory of the script
script_dir = os.path.dirname(os.path.abspath(__file__))

# Define the relative path to the JSON file
json_file_path_list = os.listdir(
    os.path.join(script_dir, "..", "..", "Sources", "pokemon-tcg-data", "cards", "en")
)
first = True

for json_file_path in json_file_path_list:
    # Opening JSON file and loading the data
    with open(
        os.path.join(
            script_dir,
            "..",
            "..",
            "Sources",
            "pokemon-tcg-data",
            "cards",
            "en",
            json_file_path,
        ), 'r', encoding='utf-8'
    ) as json_file:
        data = json.load(json_file)

    # Create a CSV file for the main objects
    main_csv_file_path = os.path.join(script_dir, "main.csv")
    with open(main_csv_file_path, "a", newline="", encoding='utf-8') as main_csv_file:
        main_csv_writer = csv.writer(main_csv_file)

        # Write the header for the main CSV file
        if first:
            main_csv_writer.writerow(data[0].keys())

        # Write the data for the main CSV file
        for item in data:
            main_csv_writer.writerow(item.values())

    # Create CSV files for "abilities" and "attacks"
    for item in data:
        for sub_item_name in ["abilities", "attacks"]:
            sub_item = item.get(sub_item_name, [])
            if sub_item:
                sub_csv_file_path = os.path.join(script_dir, f"{sub_item_name}.csv")
                with open(sub_csv_file_path, "a", newline="", encoding='utf-8') as sub_csv_file:
                    sub_csv_writer = csv.writer(sub_csv_file)

                    # Convert dict_keys to a list for the header
                    if first:
                        header = ["pokemonID"] + list(sub_item[0].keys())
                        sub_csv_writer.writerow(header)  # Header with pokemonID

                    for ability in sub_item:
                        ability["pokemonID"] = item["id"]  # Add pokemonID
                        sub_csv_writer.writerow(
                            [item["id"]] + list(ability.values())
                        )  # Write data with pokemonID
        first = False
    print("Done : " + json_file_path)

print("Done")
