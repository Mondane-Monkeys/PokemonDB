import os
import re
import json

def generate_json(input_file):
    with open(input_file, 'r') as file:
        table_definitions = file.read()

    # Split the input into individual table definitions
    tables = re.split(r'\s*;\s*', table_definitions.strip())

    for table in tables:
        table_name_match = re.search(r"CREATE TABLE IF NOT EXISTS (\w+)", table)
        if not table_name_match:
            continue
        table_name_snake_case = table_name_match.group(1)

        # Parse columns
        columns_match = re.search(r"\((.*?)\)", table, re.DOTALL)
        if not columns_match:
            continue
        columns = [col.strip() for col in columns_match.group(1).split(',')]

        col_names=[]

        for column in columns:
            if column.strip().startswith("FOREIGN KEY") or column.strip().startswith("PRIMARY KEY"):
                continue

            # Handle cases where the data type is missing
            parts = column.strip().split()
            name = parts[0]
            col_names.append(name)
        
        query = f"select {','.join(col_names)} from {table_name_snake_case};"
        print(query)

        with open(os.path.join(os.path.abspath(''), 'outputs', f"all_{table_name_snake_case}.sql"), 'w') as f:
            f.write(query)
    print("Queries creates in: ", os.path.join(os.path.abspath(''), 'outputs', "*.sql"))

generate_json("tsql_input.txt")
# print()