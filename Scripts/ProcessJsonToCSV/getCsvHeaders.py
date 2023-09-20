import os

# Get the directory of the script
script_dir = os.path.dirname(os.path.abspath(__file__))

# Define the relative path to the JSON file
file_name_list = os.listdir(
    os.path.join(script_dir, "..", "..", "Sources", "pokedex", "pokedex", "data", "csv")
)

output_file = os.path.join(script_dir, "output", "getCSVHeaders.csv")

# Open all files in file list
with open(output_file, "a") as output:
    for file_name in file_name_list:
        if not file_name.endswith("csv"):
            continue

        # Opening file
        with open(
            os.path.join(
                script_dir,
                "..",
                "..",
                "Sources", "pokedex", "pokedex", "data", "csv",
                file_name,
            ), 'r', encoding='utf-8'
        ) as file:
            # get the first line of a file
            lines = file.readlines()

            # get the [filename] part of [filename].[ext]
            file_base = os.path.splitext(file_name)[0]

            output.write(str(len(lines))+ "," + file_base + "," + lines[0])
        




