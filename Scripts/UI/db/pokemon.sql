

CREATE TABLE IF NOT EXISTS card_packs(
   name TEXT PRIMARY KEY,
   release_date TEXT
);
CREATE TABLE IF NOT EXISTS card_metadata(
   id INT PRIMARY KEY,
   pack_id INT REFERENCES card_packs(id),
   price NUM,
   image TEXT,
   artist TEXT,
   legalities TEXT,
   name TEXT,
   rarity TEXT,
   flavour_text TEXT
);
CREATE TABLE IF NOT EXISTS card_colors(
   id INT PRIMARY KEY,
   name TEXT,
   introduction TEXT
);
CREATE TABLE IF NOT EXISTS trainer_cards(
   id INT PRIMARY KEY,
   rule TEXT,
   FOREIGN KEY (id) REFERENCES card_metadata(id)
);
CREATE TABLE IF NOT EXISTS energy_cards(
   id INT PRIMARY KEY,
   rule TEXT,
   FOREIGN KEY (id) REFERENCES card_metadata(id)
);
CREATE TABLE IF NOT EXISTS energy_card_contents(
   card_id INT,
   color_id INT,
   count INT,
   FOREIGN KEY (card_id) REFERENCES energy_cards(id),
   FOREIGN KEY (color_id) REFERENCES card_colors(id),
   PRIMARY KEY (card_id, color_id)
);
CREATE TABLE IF NOT EXISTS pkmn_cards(
   id INT PRIMARY KEY,
   pkmn_id INT REFERENCES pokemon(id),
   weakness INT REFERENCES card_colors(id),
   weakness_modifier TEXT,
   level INT,
   hp INT,
   ability_text TEXT,
   ability_name TEXT,
   primary_color REFERENCES card_colors(id),
   secondary_color REFERENCES card_colors(id),
   FOREIGN KEY (id) REFERENCES card_metadata(id)
);
CREATE TABLE IF NOT EXISTS retreat_cost(
   card_id INT,
   color_id INT,
   count INT,
   FOREIGN KEY (card_id) REFERENCES pkmn_cards(id),
   FOREIGN KEY (color_id) REFERENCES card_colors(id),
   PRIMARY KEY (card_id, color_id)
);
CREATE TABLE IF NOT EXISTS pkmn_card_evolutions(
   evolve_from INT,
   evolve_into INT,
   FOREIGN KEY (evolve_from) REFERENCES pkmn_cards(id),
   FOREIGN KEY (evolve_into) REFERENCES pkmn_cards(id),
   PRIMARY KEY (evolve_from, evolve_into)
);
CREATE TABLE IF NOT EXISTS card_attacks(
   name TEXT,
   card_id INT,
   damage INT,
   text TEXT,
   FOREIGN KEY (card_id) REFERENCES pkmn_cards(id),
   PRIMARY KEY (name, card_id)
);
CREATE TABLE IF NOT EXISTS card_attack_costs(
   card_attack_name  TEXT,
   card_attack_id INT,
   type_id REFERENCES card_colors(id),
   count INT,
   FOREIGN KEY (card_attack_name) REFERENCES card_attacks(name),
   FOREIGN KEY (card_attack_id) REFERENCES card_attacks(card_id),
   PRIMARY KEY (card_attack_name, card_attack_id)
);
CREATE TABLE IF NOT EXISTS pokemon(
   id INT PRIMARY KEY,
   name TEXT,
   species_id INT,
   weight INT,
   height INT,
   base_exp INT,
   is_default INT,
   gender_distribution REAL CHECK (gender_distribution>0 AND gender_distribution<=1),
   "order" INT,
   evolve_from INT REFERENCES pokemon(id),
   primary_type INT REFERENCES types(id),
   secondary_type INT REFERENCES types(id),
   hidden_ability INT REFERENCES abilities(id)
);
CREATE TABLE IF NOT EXISTS go_stats(
   pokemon_id INT PRIMARY KEY,
   hp INT,
   cp INT,
   stamina INT,
   defense INT,
   attack INT,
   gender_ration REAL CHECK (gender_ration >0 AND gender_ration <=1),
   capture_rate REAL CHECK (capture_rate >0 AND capture_rate <=1),
   raid_available INT,
   egg_available INT,
   wild_available INT,
   flee_rate REAL CHECK (flee_rate>0 AND flee_rate<=1)
);
CREATE TABLE IF NOT EXISTS pokemon_evolution_condition(
   pokemon_id INT PRIMARY KEY,
   evo_location INT REFERENCES locations(id),
   evo_region INT REFERENCES regions(id),
   evo_game INT REFERENCES games(id),
   evo_knows_move INT REFERENCES moves(id),
   evo_time NUM,
   evo_lets_go INT,
   evo_friendship INT,
   evo_item INT REFERENCES items(id),
   evo_other TEXT,
   evo_level INT,
   evo_gender TEXT,
   evo_trading INT,
   FOREIGN KEY (pokemon_id) REFERENCES pokemon(id)
);
CREATE TABLE IF NOT EXISTS pokemon_abilities(
   pokemon_id INT,
   ability_id INT,
   FOREIGN KEY (pokemon_id) REFERENCES pokemon(id),
   FOREIGN KEY (ability_id) REFERENCES abilities(id),
   PRIMARY KEY (pokemon_id, ability_id)
);
CREATE TABLE IF NOT EXISTS pokemon_moves(
   pokemon_id INT,
   move_id INT,
   learn_method TEXT,
   level INT,
   "order" INT,
   FOREIGN KEY (pokemon_id) REFERENCES pokemon(id),
   FOREIGN KEY (move_id) REFERENCES moves(id),
   PRIMARY KEY (pokemon_id, move_id)
);
CREATE TABLE IF NOT EXISTS pokemon_egg_groups(
   pokemon_id INT,
   egg_group_id INT,
   FOREIGN KEY (pokemon_id) REFERENCES pokemon(id),
   FOREIGN KEY (egg_group_id) REFERENCES egg_groups(id),
   PRIMARY KEY (pokemon_id, egg_group_id)
);
CREATE TABLE IF NOT EXISTS moves(
   id INT PRIMARY KEY,
   name TEXT,
   power INT,
   type_id INT REFERENCES types(id),
   pp INT,
   accuracy INT,
   priority INT,
   target TEXT,
   damage_class TEXT,
   description TEXT
);
CREATE TABLE IF NOT EXISTS abilities(
   id INT PRIMARY KEY,
   name TEXT,
   is_main_series INT,
   description TEXT
);
CREATE TABLE IF NOT EXISTS egg_groups(
   id INT PRIMARY KEY,
   name TEXT
);
CREATE TABLE IF NOT EXISTS go_moves(
   id INT PRIMARY KEY,
   name TEXT,
   damage INT,
   energy INT,
   type_id INT REFERENCES types(id),
   turns INT,
   effect TEXT
);
CREATE TABLE IF NOT EXISTS exp_level_thresholds(
   level_group INT,
   level INT,
   exp_threshold INT,
   PRIMARY KEY (level_group, level)
);
CREATE TABLE IF NOT EXISTS types(
   id INT PRIMARY KEY,
   name TEXT
);
CREATE TABLE IF NOT EXISTS type_effectiveness(
   offense_type_id INT,
   defense_type_id INT,
   damage_modifier NUM,
   FOREIGN KEY (offense_type_id) REFERENCES types(id),
   FOREIGN KEY (defense_type_id) REFERENCES types(id),
   PRIMARY KEY (offense_type_id, defense_type_id)
);
CREATE TABLE IF NOT EXISTS move_effects(
   move_id INT,
   effect_id INT,
   FOREIGN KEY (move_id) REFERENCES moves(id),
   FOREIGN KEY (effect_id) REFERENCES status_effects(id),
   PRIMARY KEY (move_id, effect_id)
);
CREATE TABLE IF NOT EXISTS status_effects(
   id INT PRIMARY KEY,
   name TEXT,
   effect TEXT
);
CREATE TABLE IF NOT EXISTS type_immunity(
   effect_id INT,
   type_id INT,
   FOREIGN KEY (effect_id) REFERENCES status_effects(id),
   FOREIGN KEY (type_id) REFERENCES types(id),
   PRIMARY KEY (effect_id, type_id)
);
CREATE TABLE IF NOT EXISTS regions(
   id INT PRIMARY KEY,
   name TEXT
);
CREATE TABLE IF NOT EXISTS generations(
   id INT PRIMARY KEY,
   name TEXT,
   region_id INT REFERENCES regions(id)
);
CREATE TABLE IF NOT EXISTS games(
   id INT PRIMARY KEY,
   name TEXT,
   generation_id INT REFERENCES generation(id),
   legendary_pokemon_id INT REFERENCES pokemon(id),
   release_date TEXT
);
CREATE TABLE IF NOT EXISTS locations(
   id INT PRIMARY KEY,
   name TEXT,
   region_id INT REFERENCES regions(id)
);
CREATE TABLE IF NOT EXISTS starters(
   pokemon_id INT,
   generation_id,
   FOREIGN KEY (pokemon_id) REFERENCES pokemon(id),
   FOREIGN KEY (generation_id) REFERENCES generations(id),
   PRIMARY KEY (pokemon_id, generation_id)
);
CREATE TABLE IF NOT EXISTS trainers(
   id INT PRIMARY KEY,
   name TEXT,
   game_id INT REFERENCES game(id),
   location_id INT REFERENCES locations(id),
   is_gym_leader INT
);
CREATE TABLE IF NOT EXISTS catch_locations(
   pokemon_id INT,
   location_id INT,
   FOREIGN KEY (pokemon_id) REFERENCES pokemon(id),
   FOREIGN KEY (location_id) REFERENCES locations(id),
   PRIMARY KEY (pokemon_id, location_id)
);
CREATE TABLE IF NOT EXISTS game_pokemon(
   pokemon_id INT,
   game_id INT,
   FOREIGN KEY (pokemon_id) REFERENCES pokemon(id),
   FOREIGN KEY (game_id) REFERENCES games(id),
   PRIMARY KEY (pokemon_id, game_id)
);
CREATE TABLE IF NOT EXISTS trainer_teams(
   trainer_id INT,
   pokemon_id INT,
   level INT,
   FOREIGN KEY (trainer_id) REFERENCES trainers(id),
   FOREIGN KEY (pokemon_id) REFERENCES pokemon(id),
   PRIMARY KEY (trainer_id, pokemon_id)
);
CREATE TABLE IF NOT EXISTS items(
   id INT PRIMARY KEY,
   name TEXT,
   category TEXT,
   description TEXT,
   effects TEXT,
   generation_id INT REFERENCES generations(id),
   pkball_catch_modifier NUM,
   pkball_restriction TEXT,
   berry_dryness INT,
   berry_spiciness INT,
   berry_sourness INT,
   berry_sweetness INT,
   berry_bitterness INT
);
CREATE TABLE IF NOT EXISTS berry_locations(
   berry_id INT,
   location_id INT,
   FOREIGN KEY (berry_id) REFERENCES items(id),
   FOREIGN KEY (location_id) REFERENCES locations(id),
   PRIMARY KEY (berry_id, location_id)
);
CREATE TABLE IF NOT EXISTS natures(
   id INT PRIMARY KEY,
   name TEXT,
   favourite_flavor TEXT,
   disliked_flavor TEXT,
   game_index INT
);
CREATE TABLE IF NOT EXISTS berry_effects(
   nature_id INT,
   berry_id INT,
   attack INT,
   defense INT,
   speed INT,
   sp_attack INT,
   sp_defense INT,
   FOREIGN KEY (nature_id) REFERENCES natures(id),
   FOREIGN KEY (berry_id) REFERENCES items(id)
);
CREATE TABLE IF NOT EXISTS game_locations(
   game_id INT,
   location_id INT,
   FOREIGN KEY (game_id) REFERENCES games(id),
   FOREIGN KEY (location_id) REFERENCES locations(id),
   PRIMARY KEY (game_id, location_id)
);
CREATE TABLE IF NOT EXISTS game_items(
   game_id INT,
   item_id INT,
   FOREIGN KEY (game_id) REFERENCES games(id),
   FOREIGN KEY (item_id) REFERENCES items(id),
   PRIMARY KEY (game_id, item_id)
);
CREATE TABLE IF NOT EXISTS languages(
   id INT PRIMARY KEY,
   name TEXT
);
CREATE TABLE IF NOT EXISTS language_translations(
   language INT,
   language_id INT,
   name  TEXT,
   FOREIGN KEY (language) REFERENCES languages(id),
   FOREIGN KEY (language) REFERENCES languages(id),
   PRIMARY KEY (language_id, language)
);
CREATE TABLE IF NOT EXISTS move_translations(
   move_id INT,
   language_id INT,
   name TEXT,
   FOREIGN KEY (move_id) REFERENCES mvoes(id),
   PRIMARY KEY (move_id, language_id)
);
CREATE TABLE IF NOT EXISTS type_translations(
   type_id INT,
   language_id INT,
   name TEXT,
   FOREIGN KEY (type_id) REFERENCES types(id),
   PRIMARY KEY (type_id, language_id)
);
CREATE TABLE IF NOT EXISTS ability_translations(
   ability_id INT,
   language_id INT,
   name TEXT,
   FOREIGN KEY (ability_id) REFERENCES abilities(id),
   PRIMARY KEY (ability_id, language_id)
);
CREATE TABLE IF NOT EXISTS generation_translations(
   generation_id INT,
   language_id INT,
   name TEXT,
   FOREIGN KEY (generation_id) REFERENCES generations(id),
   PRIMARY KEY (generation_id, language_id)
);
CREATE TABLE IF NOT EXISTS region_translations(
   region_id INT,
   language_id INT,
   name TEXT,
   FOREIGN KEY (region_id) REFERENCES regions(id),
   PRIMARY KEY (region_id, language_id)
);
CREATE TABLE IF NOT EXISTS game_translations(
   game_id INT,
   language_id INT,
   name TEXT,
   FOREIGN KEY (game_id) REFERENCES games(id),
   PRIMARY KEY (game_id, language_id)
);
CREATE TABLE IF NOT EXISTS item_translations(
   item_id INT,
   language_id INT,
   name TEXT,
   FOREIGN KEY (item_id) REFERENCES items(id),
   PRIMARY KEY (item_id, language_id)
);
CREATE TABLE IF NOT EXISTS nature_translations(
   nature_id INT,
   language_id INT,
   name TEXT,
   FOREIGN KEY (nature_id) REFERENCES natures(id),
   PRIMARY KEY (nature_id, language_id)
);
CREATE TABLE IF NOT EXISTS location_translations(
   location_id INT,
   language_id INT,
   name TEXT,
   FOREIGN KEY (location_id) REFERENCES locations(id),
   PRIMARY KEY (location_id, language_id)
);
INSERT OR IGNORE INTO pokemon (id, name) values (1, 'Bulbasaur');
INSERT OR IGNORE INTO pokemon (id, name) values (2, 'Ivysaur');
INSERT OR IGNORE INTO pokemon (id, name) values (3, 'Venusaur');
INSERT OR IGNORE INTO pokemon (id, name) values (4, 'Charmander');
INSERT OR IGNORE INTO pokemon (id, name) values (5, 'Charmeleon');
INSERT OR IGNORE INTO pokemon (id, name) values (6, 'Charizard');
INSERT OR IGNORE INTO pokemon (id, name) values (7, 'Squirtle');
INSERT OR IGNORE INTO pokemon (id, name) values (8, 'Wartortle');
INSERT OR IGNORE INTO pokemon (id, name) values (9, 'Blastoise');