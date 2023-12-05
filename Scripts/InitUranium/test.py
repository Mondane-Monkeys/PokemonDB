import os

# File paths
script_path = r"F:\School\Group Project Bulk\PokemonDB\Scripts\InitUranium\init.py"
file_path = r"F:\School\Group Project Bulk\PokemonDB\Scripts\UI\db\pokemon.sql"

# Get the relative path without a base directory
relative_path = os.path.relpath(file_path, os.path.dirname(script_path))

print("Relative path:", relative_path)