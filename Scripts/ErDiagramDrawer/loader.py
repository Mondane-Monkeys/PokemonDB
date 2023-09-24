import json

from object import Entity
from object import Relation
from object import Inheritance

def load_json(json_filename):
    entities = []
    relations = []
    inherits = []

    def get_entity_by_name(name):
        for entity in entities:
            if entity.is_name(name):
                return entity
        return Entity(name, True)
    
    with open(json_filename, 'r') as file:
        data = json.load(file)

    for entity_data in data.get('entity_sets', []):
        entity = Entity(entity_data)
        entities.append(entity)

    for relation_data in data.get('relationships', []):
        relation = Relation(relation_data, get_entity_by_name)
        relations.append(relation)

    for inherits_data in data.get('inheritance', []):
        inherit = Inheritance(inherits_data, get_entity_by_name)
        inherits.append(inherit)

    return entities, relations, inherits

def save_json(json_file, entities, relations, inherits):
    entity_data = []
    relation_data = []
    inherits_data = []

    # Convert entities to JSON format
    for entity in entities:
        entity_data.append({
            "name": entity.name,
            "coordinates": [entity.x, entity.y],
            "num_entities": entity.num_entities
        })

    # Convert relations to JSON format
    for relation in relations:
        relation_data.append({
            "name": relation.name,
            "coordinates": [relation.x, relation.y],
            "entity_sets": [entity.name for entity in relation.entity_sets],
            "is_many": relation.is_many,
            "full_participation": relation.full_participation,
            "determines": relation.determines
        })

    for inheritance in inherits:
        inherits_data.append({
            "type": inheritance.name,
            "coordinates": [inheritance.x, inheritance.y],
            "entity_sets": [entity.name for entity in inheritance.entity_sets],
            "inherit_from": inheritance.inherit_from,
            "full_participation": inheritance.full_participation,
        })

    data = {
        "entity_sets": entity_data,
        "relationships": relation_data,
        "inheritance":inherits_data
    }

    # Write the JSON data to the file
    with open(json_file, 'w') as file:
        json.dump(data, file, indent=2)