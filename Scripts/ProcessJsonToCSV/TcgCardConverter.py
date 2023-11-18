import os
import json
import csv
import re

import pandas as pd

# Get the directory of the script
script_dir = os.path.dirname(os.path.abspath(__file__))

# Define the relative path to the JSON file
json_file_path_list = os.listdir(
    os.path.join(script_dir, "..", "..", "Sources", "pokemon-tcg-data", "cards", "en")
)
first = True

def json_to_csv_depricated():
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

def json_to_csv(json_files, output_directory):
    for json_file in json_files:
        json_file_path=os.path.join(script_dir,
                "..",
                "..",
                "Sources",
                "pokemon-tcg-data",
                "cards",
                "en",json_file)
        with open(json_file_path, 'r', errors="replace") as f:
            data = json.loads(clean_input(f))

        supertype_files = {}

        for entry in data:
            supertype = entry.get('supertype', 'Unknown')

            if supertype not in supertype_files:
                filename = clean_filename(os.path.join(output_directory,f'{supertype.lower()}_output.csv'))
                print(filename)
                supertype_files[supertype] = open(filename, 'w', newline='')
                fieldnames = ['id', 'name', 'subtypes', 'level', 'hp', 'types',
                            'evolvesFrom', 'abilities', 'attacks', 'rules', 'number',
                            'artist', 'rarity', 'legalities', 'images']
                writer = csv.DictWriter(supertype_files[supertype], fieldnames=fieldnames)
                writer.writeheader()

            writer = csv.DictWriter(supertype_files[supertype], fieldnames=fieldnames)
            row = {
                'id': entry.get('id', ''),
                'name': entry.get('name', ''),
                'subtypes': ', '.join(entry.get('subtypes', [])),
                'level': entry.get('level', ''),
                'hp': entry.get('hp', ''),
                'types': ', '.join(entry.get('types', [])),
                'evolvesFrom': entry.get('evolvesFrom', ''),
                'abilities': ', '.join([ability['name'] for ability in entry.get('abilities', [])]),
                'attacks': ', '.join([attack['name'] for attack in entry.get('attacks', [])]),
                'rules': ', '.join(entry.get('rules', [])),
                'number': entry.get('number', ''),
                'artist': entry.get('artist', ''),
                'rarity': entry.get('rarity', ''),
                'legalities': ', '.join([f"{key}: {value}" for key, value in entry.get('legalities', {}).items()]),
                'images': entry.get('images', {}).get('large', '')
            }
            writer.writerow(row)

    for file in supertype_files.values():
        file.close()

def flatten_lists(entry):
    # Flatten lists in the entry
    for key, value in entry.items():
        if isinstance(value, list):
            entry[key] = ', '.join(map(str, value))
    return entry

def flatten_dicts(entry, parent_key=''):
    # Recursively flatten sub-objects in the entry
    flattened = {}
    for key, value in entry.items():
        new_key = f'{parent_key}_{key}' if parent_key else key
        if isinstance(value, dict):
            flattened.update(flatten_dicts(value, new_key))
        else:
            flattened[new_key] = value
    return flattened

def json_to_csv3(json_files, output):
    all_data = []

    for json_file in json_files:
        json_file_path = os.path.join(script_dir,
                                      "..",
                                      "..",
                                      "Sources",
                                      "pokemon-tcg-data",
                                      "cards",
                                      "en", json_file)

        with open(json_file_path, encoding='utf-8') as f:
            data = pd.read_json(f)

            # Flatten lists and sub-objects in each entry
            data = data.apply(flatten_dicts, axis=1)

            # Append the data to the list
            all_data.append(data.to_dict('records'))

    # Convert the list of dictionaries to a DataFrame
    output_df = pd.DataFrame([item for sublist in all_data for item in sublist])

    # Write the DataFrame to the output CSV file
    output_df.to_csv(output, encoding='utf-8', index=False)

def clean_filename(s):
    # Remove non-ASCII characters
    return re.sub(r'[^\x00-\x7F]+', '', s)

def clean_input(f):
    s = f.read()
    # Replace special characters with UTF-8 equivalents
    if '\ufffd' in s:
        print("ahh")
    out = s.replace('\ufffd', '')
    return out


def json_to_csv4(json_files, output_dir):
    meta_list = []
    pokemon_list = []
    trainer_list = []
    energy_list = []
    attack_list = []
    attack_cost_list = []
    retreat_cost_list = []
    for json_file in json_files:
        json_file_path = os.path.join(script_dir,
                                      "..",
                                      "..",
                                      "Sources",
                                      "pokemon-tcg-data",
                                      "cards",
                                      "en", json_file)
        print(json_file_path)
        with open(json_file_path, encoding='utf-8') as f:
            data = json.loads(f.read())
            meta_cards, pokemon_cards, trainer_cards, energy_cards, attack_cards, attack_cost_cards, retreat_cost_cards= flatten_objects(data, meta_list, pokemon_list, trainer_list, energy_list, attack_list, attack_cost_list, retreat_cost_list)

    # Convert flattened lists to DataFrames
    df_meta = pd.DataFrame(meta_cards)
    df_pokemon = pd.DataFrame(pokemon_cards)
    df_trainer = pd.DataFrame(trainer_cards)
    df_energy = pd.DataFrame(energy_cards)
    df_attack = pd.DataFrame(attack_cards)
    df_attack_cost = pd.DataFrame(attack_cost_cards)
    df_retreat_cost = pd.DataFrame(retreat_cost_cards)

    # Output each DataFrame to its own CSV file
    print(os.path.join(output_dir, 'card_pokemon.csv'))
    df_meta.to_csv(os.path.join(output_dir, 'card_meta.csv'), encoding='utf-8', index=False)
    df_pokemon.to_csv(os.path.join(output_dir, 'card_pokemon.csv'), encoding='utf-8', index=False)
    df_trainer.to_csv(os.path.join(output_dir, 'card_trainer.csv'), encoding='utf-8', index=False)
    df_energy.to_csv(os.path.join(output_dir, 'card_energy.csv'), encoding='utf-8', index=False)
    df_attack.to_csv(os.path.join(output_dir, 'card_attack.csv'), encoding='utf-8', index=False)
    df_attack_cost.to_csv(os.path.join(output_dir, 'card_attack_cost.csv'), encoding='utf-8', index=False)
    df_retreat_cost.to_csv(os.path.join(output_dir, 'card_retreat_cost.csv'), encoding='utf-8', index=False)


def flatten_data(y):
    out = {}

    def flatten(x, name=''):
        if type(x) is dict:
            for a in x:
                flatten(x[a], name + a + '_')
        elif type(x) is list:
            i = 0
            for a in x:
                flatten(a, name + str(i) + '_')
                i += 1
        else:
            out[name[:-1]] = x

    flatten(y)
    return out

def flatten_objects(cards, meta_list, pokemon_list, trainer_list, energy_list, attack_list, attack_cost_list, retreat_cost_list):

    for card in cards:
        #id, name, supertype, subtype, rules, number, artist, rarity, legalities_unlimited, legalities_expanded, images_small, images_large
        meta_list.append(flatten_meta(card))
        if card["supertype"] == "Pokémon":
            # Flatten Pokémon
            pokemon = {
                "id": card["id"],
                "name": card["name"],
                "nationalPokedexNumbers": card.get("nationalPokedexNumbers", ""),
                "level": card.get("level", ""),
                "hp": card.get("hp", ""),
                "type1": card.get("types", [""])[0],
                "type2":",".join(card.get("types", ["", ""])[1:]),
                "evolvesFrom":card.get("evolvesFrom", ""),
                "weaknessColor":card.get("weaknesses", [{"type":""}])[0].get("type", ""),
                "weaknessModifier":card.get("weaknesses", [{"value":""}])[0].get("value", ""),
                "ability_name":card.get("abilities", [{"name":""}])[0].get("name", ""),
                "ability_text":card.get("abilities", [{"text":""}])[0].get("text", ""),
                "ability_type":card.get("abilities", [{"type":""}])[0].get("type", ""),
                # Add other fields as needed
            }
            pokemon_list.append(pokemon)
            rc = flatten_retreat_cost(card["id"], card.get("retreatCost", []))
            if len(rc)>0:
                retreat_cost_list.extend(rc)
            # Extract and flatten attacks
            for attack in card.get("attacks", []):
                attack_info = {
                    "pokemon_id": card["id"],
                    "name": attack["name"],
                    "cost": ", ".join(attack["cost"]),
                    "convertedEnergyCost": attack["convertedEnergyCost"],
                    "damage": attack.get("damage", ""),
                    "text": attack.get("text", ""),
                }
                attack_list.append(attack_info)

                # Extract and flatten attack costs
                attack_cost_list.extend(flatten_costs(card["id"], attack["name"], attack["cost"]))

        elif card["supertype"] == "Trainer":
            # Flatten Trainer
            trainer = {
                "id": card["id"],
                "name": card["name"],
                "rules": ", ".join(card.get("rules", [])),
                # Add other fields as needed
            }
            trainer_list.append(trainer)

        elif card["supertype"] == "Energy":
            # Flatten Energy
            energy = {
                "id": card["id"],
                "name": card["name"],
                "subtypes": ", ".join(card.get("subtypes", [])),
                "rules":", ".join(card.get("rules", [])),
                # Add other fields as needed
            }
            energy_list.append(energy)

    return meta_list, pokemon_list, trainer_list, energy_list, attack_list, attack_cost_list, retreat_cost_list

def flatten_costs(pokemon, attack_name, costs):
    flattened_costs = []
    cost_counts = {}

    for cost_type in costs:
        if cost_type not in cost_counts:
            cost_counts[cost_type] = 1
        else:
            cost_counts[cost_type] += 1

    for cost_type, count in cost_counts.items():
        flattened_cost = {
            "pokemon": pokemon,
            "attack_name": attack_name,
            "type": cost_type,
            "count": count,
        }
        flattened_costs.append(flattened_cost)
    return flattened_costs

def flatten_retreat_cost(pokemon, costs):
    flattened_costs = []
    cost_counts = {}
    for cost_type in costs:
        if cost_type not in cost_counts:
            cost_counts[cost_type] = 1
        else:
            cost_counts[cost_type] += 1
    for cost_type, count in cost_counts.items():
        flattened_cost = {
            "pokemon": pokemon,
            "type": cost_type,
            "count": count,
        }
        flattened_costs.append(flattened_cost)
    return flattened_costs


def flatten_meta(card):
    return {
        "id": card.get("id", ""),
        "name": card.get("name", ""),
        "supertype": card.get("supertype", ""),
        "subtype": ", ".join(card.get("subtypes", [])),
        "rules": ", ".join(card.get("rules", [])),
        "number": card.get("number", ""),
        "artist": card.get("artist", ""),
        "rarity": card.get("rarity", ""),
        "legalities_unlimited": card.get("legalities", {}).get("unlimited", ""),
        "legalities_expanded": card.get("legalities", {}).get("expanded", ""),
        "images_small": card.get("images", {}).get("small", ""),
        "images_large": card.get("images", {}).get("large", ""),
    }


if __name__ == "__main__":
    # json_to_csv(json_file_path_list, os.path.join(script_dir, 'output'))
    json_to_csv4(json_file_path_list, os.path.join(script_dir, 'output'))