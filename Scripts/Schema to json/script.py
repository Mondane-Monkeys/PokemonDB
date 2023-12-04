import re
import json

# Much credit to chat gpt for providing. we sleep good tonight thanks to its gracious help

def remove_Char(text):
    return text.replace('_', ' ').title()

def generate_json(input_file):
    with open(input_file, 'r') as file:
        table_definitions = file.read()

    # Split the input into individual table definitions
    tables = re.split(r'\s*;\s*', table_definitions.strip())

    json_output = {}

    for table in tables:
        table_name_match = re.search(r"CREATE TABLE IF NOT EXISTS (\w+)", table)
        if not table_name_match:
            continue
        table_name_snake_case = table_name_match.group(1)
        table_name_title_case = remove_Char(table_name_snake_case)

        # Parse columns
        columns_match = re.search(r"\((.*?)\)", table, re.DOTALL)
        if not columns_match:
            continue
        columns = [col.strip() for col in columns_match.group(1).split(',')]

        json_output[f"All {table_name_title_case}"] = {
            "parameters": [],
            "return_parameters": [],
            "display": "value",
            "sql_file": f"all_{table_name_snake_case.lower()}.sql"
        }

        order = 1
        for column in columns:
            if column.strip().startswith("FOREIGN KEY"):
                continue

            # Handle cases where the data type is missing
            parts = column.strip().split()
            name = parts[0]
            data_type = parts[1] if len(parts) > 1 else "TEXT"
            
            parameter_type = "string" if "TEXT" in data_type else "int"

            json_output[f"All {table_name_title_case}"]["return_parameters"].append({
                "name": f"{remove_Char(name)} {data_type}",
                "order": [order],  # Keep order as a list
                "type": parameter_type
            })

            order += 1

    with open('output.json', 'w') as json_file:
        json.dump(json_output, json_file, indent=2)

input_file = "input.txt"
generate_json(input_file)
