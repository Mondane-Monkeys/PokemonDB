import os

# Get the directory of the script
script_dir = os.path.dirname(os.path.abspath(__file__))

# Define the relative path to the JSON file
json_file_path_list = os.listdir(
    os.path.join(script_dir, "..", "..", "Sources", "pokemon-tcg-data", "cards", "en")
)

for file_path in json_file_path_list:
    path = os.path.join(
            script_dir,
            "..",
            "..",
            "Sources",
            "pokemon-tcg-data",
            "cards",
            "en",
            file_path,
        )
    # Read the content of the file
    with open(path, 'r', encoding='utf-8') as file:
        file_content = file.read()

    # Replace curly double quotation marks with << and >>
    replaced_content = file_content.replace('“', '<<').replace('”', '>>')

    # Write the modified content back to the file
    with open(path, 'w', encoding='utf-8') as file:
        file.write(replaced_content)
print("done")