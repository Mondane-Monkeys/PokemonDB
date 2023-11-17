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
--NO DEPENDANCIES
-- card_packs
-- card_colors
-- types
INSERT INTO types (id,name) VALUES ('1','normal');
INSERT INTO types (id,name) VALUES ('2','fighting');
INSERT INTO types (id,name) VALUES ('3','flying');
INSERT INTO types (id,name) VALUES ('4','poison');
INSERT INTO types (id,name) VALUES ('5','ground');
INSERT INTO types (id,name) VALUES ('6','rock');
INSERT INTO types (id,name) VALUES ('7','bug');
INSERT INTO types (id,name) VALUES ('8','ghost');
INSERT INTO types (id,name) VALUES ('9','steel');
INSERT INTO types (id,name) VALUES ('10','fire');
INSERT INTO types (id,name) VALUES ('11','water');
INSERT INTO types (id,name) VALUES ('12','grass');
INSERT INTO types (id,name) VALUES ('13','electric');
INSERT INTO types (id,name) VALUES ('14','psychic');
INSERT INTO types (id,name) VALUES ('15','ice');
INSERT INTO types (id,name) VALUES ('16','dragon');
INSERT INTO types (id,name) VALUES ('17','dark');
INSERT INTO types (id,name) VALUES ('18','fairy');
INSERT INTO types (id,name) VALUES ('10001','unknown');
INSERT INTO types (id,name) VALUES ('10002','shadow');

-- moves (just type)
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('1','pound','1','40','100','35','0','10','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('2','karate-chop','2','50','100','25','0','10','2','44');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('3','double-slap','1','15','85','10','0','10','2','30');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('4','comet-punch','1','18','85','15','0','10','2','30');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('5','mega-punch','1','80','85','20','0','10','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('6','pay-day','1','40','100','20','0','10','2','35');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('7','fire-punch','10','75','100','15','0','10','2','5');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('8','ice-punch','15','75','100','15','0','10','2','6');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('9','thunder-punch','13','75','100','15','0','10','2','7');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('10','scratch','1','40','100','35','0','10','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('11','vice-grip','1','55','100','30','0','10','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('12','guillotine','1','','30','5','0','10','2','39');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('13','razor-wind','1','80','100','10','0','11','3','40');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('14','swords-dance','1','','','20','0','7','1','51');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('15','cut','1','50','95','30','0','10','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('16','gust','3','40','100','35','0','10','3','150');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('17','wing-attack','3','60','100','35','0','10','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('18','whirlwind','1','','','20','-6','10','1','29');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('19','fly','3','90','95','15','0','10','2','156');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('20','bind','1','15','85','20','0','10','2','43');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('21','slam','1','80','75','20','0','10','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('22','vine-whip','12','45','100','25','0','10','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('23','stomp','1','65','100','20','0','10','2','151');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('24','double-kick','2','30','100','30','0','10','2','45');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('25','mega-kick','1','120','75','5','0','10','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('26','jump-kick','2','100','95','10','0','10','2','46');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('27','rolling-kick','2','60','85','15','0','10','2','32');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('28','sand-attack','5','','100','15','0','10','1','24');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('29','headbutt','1','70','100','15','0','10','2','32');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('30','horn-attack','1','65','100','25','0','10','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('31','fury-attack','1','15','85','20','0','10','2','30');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('32','horn-drill','1','','30','5','0','10','2','39');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('33','tackle','1','40','100','35','0','10','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('34','body-slam','1','85','100','15','0','10','2','7');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('35','wrap','1','15','90','20','0','10','2','43');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('36','take-down','1','90','85','20','0','10','2','49');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('37','thrash','1','120','100','10','0','8','2','28');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('38','double-edge','1','120','100','15','0','10','2','199');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('39','tail-whip','1','','100','30','0','11','1','20');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('40','poison-sting','4','15','100','35','0','10','2','3');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('41','twineedle','7','25','100','20','0','10','2','78');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('42','pin-missile','7','25','95','20','0','10','2','30');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('43','leer','1','','100','30','0','11','1','20');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('44','bite','17','60','100','25','0','10','2','32');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('45','growl','1','','100','40','0','11','1','19');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('46','roar','1','','','20','-6','10','1','29');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('47','sing','1','','55','15','0','10','1','2');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('48','supersonic','1','','55','20','0','10','1','50');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('49','sonic-boom','1','','90','20','0','10','3','131');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('50','disable','1','','100','20','0','10','1','87');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('51','acid','4','40','100','30','0','11','3','73');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('52','ember','10','40','100','25','0','10','3','5');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('53','flamethrower','10','90','100','15','0','10','3','5');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('54','mist','15','','','30','0','4','1','47');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('55','water-gun','11','40','100','25','0','10','3','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('56','hydro-pump','11','110','80','5','0','10','3','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('57','surf','11','90','100','15','0','9','3','258');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('58','ice-beam','15','90','100','10','0','10','3','6');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('59','blizzard','15','110','70','5','0','11','3','261');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('60','psybeam','14','65','100','20','0','10','3','77');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('61','bubble-beam','11','65','100','20','0','10','3','71');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('62','aurora-beam','15','65','100','20','0','10','3','69');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('63','hyper-beam','1','150','90','5','0','10','3','81');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('64','peck','3','35','100','35','0','10','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('65','drill-peck','3','80','100','20','0','10','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('66','submission','2','80','80','20','0','10','2','49');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('67','low-kick','2','','100','20','0','10','2','197');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('68','counter','2','','100','20','-5','1','2','90');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('69','seismic-toss','2','','100','20','0','10','2','88');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('70','strength','1','80','100','15','0','10','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('71','absorb','12','20','100','25','0','10','3','4');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('72','mega-drain','12','40','100','15','0','10','3','4');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('73','leech-seed','12','','90','10','0','10','1','85');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('74','growth','1','','','20','0','7','1','317');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('75','razor-leaf','12','55','95','25','0','11','2','44');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('76','solar-beam','12','120','100','10','0','10','3','152');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('77','poison-powder','4','','75','35','0','10','1','67');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('78','stun-spore','12','','75','30','0','10','1','68');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('79','sleep-powder','12','','75','15','0','10','1','2');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('80','petal-dance','12','120','100','10','0','8','3','28');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('81','string-shot','7','','95','40','0','11','1','61');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('82','dragon-rage','16','','100','10','0','10','3','42');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('83','fire-spin','10','35','85','15','0','10','3','43');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('84','thunder-shock','13','40','100','30','0','10','3','7');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('85','thunderbolt','13','90','100','15','0','10','3','7');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('86','thunder-wave','13','','90','20','0','10','1','68');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('87','thunder','13','110','70','10','0','10','3','153');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('88','rock-throw','6','50','90','15','0','10','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('89','earthquake','5','100','100','10','0','9','2','148');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('90','fissure','5','','30','5','0','10','2','39');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('91','dig','5','80','100','10','0','10','2','257');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('92','toxic','4','','90','10','0','10','1','34');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('93','confusion','14','50','100','25','0','10','3','77');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('94','psychic','14','90','100','10','0','10','3','73');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('95','hypnosis','14','','60','20','0','10','1','2');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('96','meditate','14','','','40','0','7','1','11');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('97','agility','14','','','30','0','7','1','53');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('98','quick-attack','1','40','100','30','1','10','2','104');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('99','rage','1','20','100','20','0','10','2','82');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('100','teleport','14','','','20','-6','7','1','154');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('101','night-shade','8','','100','15','0','10','3','88');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('102','mimic','1','','','10','0','10','1','83');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('103','screech','1','','85','40','0','10','1','60');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('104','double-team','1','','','15','0','7','1','17');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('105','recover','1','','','10','0','7','1','33');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('106','harden','1','','','30','0','7','1','12');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('107','minimize','1','','','10','0','7','1','109');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('108','smokescreen','1','','100','20','0','10','1','24');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('109','confuse-ray','8','','100','10','0','10','1','50');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('110','withdraw','11','','','40','0','7','1','12');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('111','defense-curl','1','','','40','0','7','1','157');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('112','barrier','14','','','20','0','7','1','52');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('113','light-screen','14','','','30','0','4','1','36');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('114','haze','15','','','30','0','12','1','26');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('115','reflect','14','','','20','0','4','1','66');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('116','focus-energy','1','','','30','0','7','1','48');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('117','bide','1','','','10','1','7','2','27');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('118','metronome','1','','','10','0','7','1','84');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('119','mirror-move','3','','','20','0','10','1','10');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('120','self-destruct','1','200','100','5','0','9','2','8');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('121','egg-bomb','1','100','75','10','0','10','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('122','lick','8','30','100','30','0','10','2','7');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('123','smog','4','30','70','20','0','10','3','3');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('124','sludge','4','65','100','20','0','10','3','3');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('125','bone-club','5','65','85','20','0','10','2','32');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('126','fire-blast','10','110','85','5','0','10','3','5');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('127','waterfall','11','80','100','15','0','10','2','32');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('128','clamp','11','35','85','15','0','10','2','43');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('129','swift','1','60','','20','0','11','3','18');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('130','skull-bash','1','130','100','10','0','10','2','146');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('131','spike-cannon','1','20','100','15','0','10','2','30');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('132','constrict','1','10','100','35','0','10','2','71');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('133','amnesia','14','','','20','0','7','1','55');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('134','kinesis','14','','80','15','0','10','1','24');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('135','soft-boiled','1','','','10','0','7','1','33');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('136','high-jump-kick','2','130','90','10','0','10','2','46');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('137','glare','1','','100','30','0','10','1','68');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('138','dream-eater','14','100','100','15','0','10','3','9');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('139','poison-gas','4','','90','40','0','11','1','67');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('140','barrage','1','15','85','20','0','10','2','30');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('141','leech-life','7','80','100','10','0','10','2','4');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('142','lovely-kiss','1','','75','10','0','10','1','2');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('143','sky-attack','3','140','90','5','0','10','2','76');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('144','transform','1','','','10','0','10','1','58');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('145','bubble','11','40','100','30','0','11','3','71');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('146','dizzy-punch','1','70','100','10','0','10','2','77');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('147','spore','12','','100','15','0','10','1','2');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('148','flash','1','','100','20','0','10','1','24');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('149','psywave','14','','100','15','0','10','3','89');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('150','splash','1','','','40','0','7','1','86');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('151','acid-armor','4','','','20','0','7','1','52');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('152','crabhammer','11','100','90','10','0','10','2','44');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('153','explosion','1','250','100','5','0','9','2','8');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('154','fury-swipes','1','18','80','15','0','10','2','30');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('155','bonemerang','5','50','90','10','0','10','2','45');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('156','rest','14','','','10','0','7','1','38');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('157','rock-slide','6','75','90','10','0','11','2','32');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('158','hyper-fang','1','80','90','15','0','10','2','32');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('159','sharpen','1','','','30','0','7','1','11');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('160','conversion','1','','','30','0','7','1','31');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('161','tri-attack','1','80','100','10','0','10','3','37');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('162','super-fang','1','','90','10','0','10','2','41');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('163','slash','1','70','100','20','0','10','2','44');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('164','substitute','1','','','10','0','7','1','80');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('165','struggle','1','50','','1','0','8','2','255');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('166','sketch','1','','','1','0','10','1','96');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('167','triple-kick','2','10','90','10','0','10','2','105');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('168','thief','17','60','100','25','0','10','2','106');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('169','spider-web','7','','','10','0','10','1','107');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('170','mind-reader','1','','','5','0','10','1','95');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('171','nightmare','8','','100','15','0','10','1','108');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('172','flame-wheel','10','60','100','25','0','10','2','126');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('173','snore','1','50','100','15','0','10','3','93');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('174','curse','8','','','10','0','1','1','110');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('175','flail','1','','100','15','0','10','2','100');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('176','conversion-2','1','','','30','0','10','1','94');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('177','aeroblast','3','100','95','5','0','10','3','44');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('178','cotton-spore','12','','100','40','0','11','1','61');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('179','reversal','2','','100','15','0','10','2','100');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('180','spite','8','','100','10','0','10','1','101');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('181','powder-snow','15','40','100','25','0','11','3','6');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('182','protect','1','','','10','4','7','1','112');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('183','mach-punch','2','40','100','30','1','10','2','104');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('184','scary-face','1','','100','10','0','10','1','61');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('185','feint-attack','17','60','','20','0','10','2','18');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('186','sweet-kiss','18','','75','10','0','10','1','50');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('187','belly-drum','1','','','10','0','7','1','143');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('188','sludge-bomb','4','90','100','10','0','10','3','3');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('189','mud-slap','5','20','100','10','0','10','3','74');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('190','octazooka','11','65','85','10','0','10','3','74');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('191','spikes','5','','','20','0','6','1','113');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('192','zap-cannon','13','120','50','5','0','10','3','7');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('193','foresight','1','','','40','0','10','1','114');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('194','destiny-bond','8','','','5','0','7','1','99');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('195','perish-song','1','','','5','0','14','1','115');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('196','icy-wind','15','55','95','15','0','11','3','71');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('197','detect','2','','','5','4','7','1','112');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('198','bone-rush','5','25','90','10','0','10','2','30');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('199','lock-on','1','','','5','0','10','1','95');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('200','outrage','16','120','100','10','0','8','2','28');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('201','sandstorm','6','','','10','0','12','1','116');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('202','giga-drain','12','75','100','10','0','10','3','4');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('203','endure','1','','','10','4','7','1','117');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('204','charm','18','','100','20','0','10','1','59');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('205','rollout','6','30','90','20','0','10','2','118');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('206','false-swipe','1','40','100','40','0','10','2','102');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('207','swagger','1','','85','15','0','10','1','119');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('208','milk-drink','1','','','10','0','7','1','33');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('209','spark','13','65','100','20','0','10','2','7');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('210','fury-cutter','7','40','95','20','0','10','2','120');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('211','steel-wing','9','70','90','25','0','10','2','139');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('212','mean-look','1','','','5','0','10','1','107');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('213','attract','1','','100','15','0','10','1','121');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('214','sleep-talk','1','','','10','0','7','1','98');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('215','heal-bell','1','','','5','0','13','1','103');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('216','return','1','','100','20','0','10','2','122');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('217','present','1','','90','15','0','10','2','123');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('218','frustration','1','','100','20','0','10','2','124');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('219','safeguard','1','','','25','0','4','1','125');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('220','pain-split','1','','','20','0','10','1','92');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('221','sacred-fire','10','100','95','5','0','10','2','126');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('222','magnitude','5','','100','30','0','9','2','127');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('223','dynamic-punch','2','100','50','5','0','10','2','77');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('224','megahorn','7','120','85','10','0','10','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('225','dragon-breath','16','60','100','20','0','10','3','7');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('226','baton-pass','1','','','40','0','7','1','128');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('227','encore','1','','100','5','0','10','1','91');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('228','pursuit','17','40','100','20','0','10','2','129');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('229','rapid-spin','1','50','100','40','0','10','2','130');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('230','sweet-scent','1','','100','20','0','11','1','25');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('231','iron-tail','9','100','75','15','0','10','2','70');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('232','metal-claw','9','50','95','35','0','10','2','140');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('233','vital-throw','2','70','','10','-1','10','2','79');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('234','morning-sun','1','','','5','0','7','1','133');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('235','synthesis','12','','','5','0','7','1','133');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('236','moonlight','18','','','5','0','7','1','133');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('237','hidden-power','1','60','100','15','0','10','3','136');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('238','cross-chop','2','100','80','5','0','10','2','44');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('239','twister','16','40','100','20','0','11','3','147');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('240','rain-dance','11','','','5','0','12','1','137');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('241','sunny-day','10','','','5','0','12','1','138');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('242','crunch','17','80','100','15','0','10','2','70');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('243','mirror-coat','14','','100','20','-5','1','3','145');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('244','psych-up','1','','','10','0','10','1','144');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('245','extreme-speed','1','80','100','5','2','10','2','104');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('246','ancient-power','6','60','100','5','0','10','3','141');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('247','shadow-ball','8','80','100','15','0','10','3','73');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('248','future-sight','14','120','100','10','0','10','3','149');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('249','rock-smash','2','40','100','15','0','10','2','70');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('250','whirlpool','11','35','85','15','0','10','3','262');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('251','beat-up','17','','100','10','0','10','2','155');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('252','fake-out','1','40','100','10','3','10','2','159');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('253','uproar','1','90','100','10','0','8','3','160');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('254','stockpile','1','','','20','0','7','1','161');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('255','spit-up','1','','100','10','0','10','3','162');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('256','swallow','1','','','10','0','7','1','163');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('257','heat-wave','10','95','90','10','0','11','3','5');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('258','hail','15','','','10','0','12','1','165');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('259','torment','17','','100','15','0','10','1','166');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('260','flatter','17','','100','15','0','10','1','167');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('261','will-o-wisp','10','','85','15','0','10','1','168');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('262','memento','17','','100','10','0','10','1','169');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('263','facade','1','70','100','20','0','10','2','170');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('264','focus-punch','2','150','100','20','-3','10','2','171');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('265','smelling-salts','1','70','100','10','0','10','2','172');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('266','follow-me','1','','','20','2','7','1','173');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('267','nature-power','1','','','20','0','10','1','174');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('268','charge','13','','','20','0','7','1','175');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('269','taunt','17','','100','20','0','10','1','176');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('270','helping-hand','1','','','20','5','3','1','177');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('271','trick','14','','100','10','0','10','1','178');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('272','role-play','14','','','10','0','10','1','179');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('273','wish','1','','','10','0','7','1','180');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('274','assist','1','','','20','0','7','1','181');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('275','ingrain','12','','','20','0','7','1','182');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('276','superpower','2','120','100','5','0','10','2','183');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('277','magic-coat','14','','','15','4','7','1','184');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('278','recycle','1','','','10','0','7','1','185');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('279','revenge','2','60','100','10','-4','10','2','186');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('280','brick-break','2','75','100','15','0','10','2','187');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('281','yawn','1','','','10','0','10','1','188');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('282','knock-off','17','65','100','20','0','10','2','189');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('283','endeavor','1','','100','5','0','10','2','190');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('284','eruption','10','150','100','5','0','11','3','191');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('285','skill-swap','14','','','10','0','10','1','192');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('286','imprison','14','','','10','0','7','1','193');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('287','refresh','1','','','20','0','7','1','194');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('288','grudge','8','','','5','0','7','1','195');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('289','snatch','17','','','10','4','7','1','196');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('290','secret-power','1','70','100','20','0','10','2','198');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('291','dive','11','80','100','10','0','10','2','256');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('292','arm-thrust','2','15','100','20','0','10','2','30');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('293','camouflage','1','','','20','0','7','1','214');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('294','tail-glow','7','','','20','0','7','1','322');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('295','luster-purge','14','70','100','5','0','10','3','73');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('296','mist-ball','14','70','100','5','0','10','3','72');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('297','feather-dance','3','','100','15','0','10','1','59');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('298','teeter-dance','1','','100','20','0','9','1','200');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('299','blaze-kick','10','85','90','10','0','10','2','201');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('300','mud-sport','5','','','15','0','12','1','202');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('301','ice-ball','15','30','90','20','0','10','2','118');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('302','needle-arm','12','60','100','15','0','10','2','32');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('303','slack-off','1','','','10','0','7','1','33');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('304','hyper-voice','1','90','100','10','0','11','3','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('305','poison-fang','4','50','100','15','0','10','2','203');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('306','crush-claw','1','75','95','10','0','10','2','70');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('307','blast-burn','10','150','90','5','0','10','3','81');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('308','hydro-cannon','11','150','90','5','0','10','3','81');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('309','meteor-mash','9','90','90','10','0','10','2','140');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('310','astonish','8','30','100','15','0','10','2','32');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('311','weather-ball','1','50','100','10','0','10','3','204');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('312','aromatherapy','12','','','5','0','13','1','103');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('313','fake-tears','17','','100','20','0','10','1','63');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('314','air-cutter','3','60','95','25','0','11','3','44');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('315','overheat','10','130','90','5','0','10','3','205');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('316','odor-sleuth','1','','','40','0','10','1','114');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('317','rock-tomb','6','60','95','15','0','10','2','71');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('318','silver-wind','7','60','100','5','0','10','3','141');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('319','metal-sound','9','','85','40','0','10','1','63');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('320','grass-whistle','12','','55','15','0','10','1','2');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('321','tickle','1','','100','20','0','10','1','206');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('322','cosmic-power','14','','','20','0','7','1','207');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('323','water-spout','11','150','100','5','0','11','3','191');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('324','signal-beam','7','75','100','15','0','10','3','77');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('325','shadow-punch','8','60','','20','0','10','2','18');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('326','extrasensory','14','80','100','20','0','10','3','32');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('327','sky-uppercut','2','85','90','15','0','10','2','208');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('328','sand-tomb','5','35','85','15','0','10','2','43');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('329','sheer-cold','15','','30','5','0','10','3','39');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('330','muddy-water','11','90','85','10','0','11','3','74');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('331','bullet-seed','12','25','100','30','0','10','2','30');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('332','aerial-ace','3','60','','20','0','10','2','18');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('333','icicle-spear','15','25','100','30','0','10','2','30');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('334','iron-defense','9','','','15','0','7','1','52');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('335','block','1','','','5','0','10','1','107');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('336','howl','1','','','40','0','13','1','11');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('337','dragon-claw','16','80','100','15','0','10','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('338','frenzy-plant','12','150','90','5','0','10','3','81');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('339','bulk-up','2','','','20','0','7','1','209');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('340','bounce','3','85','85','5','0','10','2','264');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('341','mud-shot','5','55','95','15','0','10','3','71');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('342','poison-tail','4','50','100','25','0','10','2','210');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('343','covet','1','60','100','25','0','10','2','106');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('344','volt-tackle','13','120','100','15','0','10','2','263');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('345','magical-leaf','12','60','','20','0','10','3','18');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('346','water-sport','11','','','15','0','12','1','211');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('347','calm-mind','14','','','20','0','7','1','212');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('348','leaf-blade','12','90','100','15','0','10','2','44');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('349','dragon-dance','16','','','20','0','7','1','213');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('350','rock-blast','6','25','90','10','0','10','2','30');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('351','shock-wave','13','60','','20','0','10','3','18');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('352','water-pulse','11','60','100','20','0','10','3','77');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('353','doom-desire','9','140','100','5','0','10','3','149');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('354','psycho-boost','14','140','90','5','0','10','3','205');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('355','roost','3','','','10','0','7','1','215');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('356','gravity','14','','','5','0','12','1','216');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('357','miracle-eye','14','','','40','0','10','1','217');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('358','wake-up-slap','2','70','100','10','0','10','2','218');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('359','hammer-arm','2','100','90','10','0','10','2','219');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('360','gyro-ball','9','','100','5','0','10','2','220');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('361','healing-wish','14','','','10','0','7','1','221');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('362','brine','11','65','100','10','0','10','3','222');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('363','natural-gift','1','','100','15','0','10','2','223');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('364','feint','1','30','100','10','2','10','2','224');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('365','pluck','3','60','100','20','0','10','2','225');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('366','tailwind','3','','','15','0','4','1','226');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('367','acupressure','1','','','30','0','5','1','227');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('368','metal-burst','9','','100','10','0','1','2','228');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('369','u-turn','7','70','100','20','0','10','2','229');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('370','close-combat','2','120','100','5','0','10','2','230');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('371','payback','17','50','100','10','0','10','2','231');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('372','assurance','17','60','100','10','0','10','2','232');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('373','embargo','17','','100','15','0','10','1','233');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('374','fling','17','','100','10','0','10','2','234');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('375','psycho-shift','14','','100','10','0','10','1','235');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('376','trump-card','1','','','5','0','10','3','236');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('377','heal-block','14','','100','15','0','11','1','237');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('378','wring-out','1','','100','5','0','10','3','238');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('379','power-trick','14','','','10','0','7','1','239');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('380','gastro-acid','4','','100','10','0','10','1','240');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('381','lucky-chant','1','','','30','0','4','1','241');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('382','me-first','1','','','20','0','2','1','242');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('383','copycat','1','','','20','0','7','1','243');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('384','power-swap','14','','','10','0','10','1','244');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('385','guard-swap','14','','','10','0','10','1','245');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('386','punishment','17','','100','5','0','10','2','246');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('387','last-resort','1','140','100','5','0','10','2','247');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('388','worry-seed','12','','100','10','0','10','1','248');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('389','sucker-punch','17','70','100','5','1','10','2','249');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('390','toxic-spikes','4','','','20','0','6','1','250');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('391','heart-swap','14','','','10','0','10','1','251');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('392','aqua-ring','11','','','20','0','7','1','252');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('393','magnet-rise','13','','','10','0','7','1','253');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('394','flare-blitz','10','120','100','15','0','10','2','254');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('395','force-palm','2','60','100','10','0','10','2','7');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('396','aura-sphere','2','80','','20','0','10','3','18');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('397','rock-polish','6','','','20','0','7','1','53');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('398','poison-jab','4','80','100','20','0','10','2','3');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('399','dark-pulse','17','80','100','15','0','10','3','32');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('400','night-slash','17','70','100','15','0','10','2','44');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('401','aqua-tail','11','90','90','10','0','10','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('402','seed-bomb','12','80','100','15','0','10','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('403','air-slash','3','75','95','15','0','10','3','32');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('404','x-scissor','7','80','100','15','0','10','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('405','bug-buzz','7','90','100','10','0','10','3','73');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('406','dragon-pulse','16','85','100','10','0','10','3','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('407','dragon-rush','16','100','75','10','0','10','2','32');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('408','power-gem','6','80','100','20','0','10','3','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('409','drain-punch','2','75','100','10','0','10','2','4');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('410','vacuum-wave','2','40','100','30','1','10','3','104');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('411','focus-blast','2','120','70','5','0','10','3','73');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('412','energy-ball','12','90','100','10','0','10','3','73');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('413','brave-bird','3','120','100','15','0','10','2','199');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('414','earth-power','5','90','100','10','0','10','3','73');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('415','switcheroo','17','','100','10','0','10','1','178');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('416','giga-impact','1','150','90','5','0','10','2','81');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('417','nasty-plot','17','','','20','0','7','1','54');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('418','bullet-punch','9','40','100','30','1','10','2','104');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('419','avalanche','15','60','100','10','-4','10','2','186');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('420','ice-shard','15','40','100','30','1','10','2','104');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('421','shadow-claw','8','70','100','15','0','10','2','44');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('422','thunder-fang','13','65','95','15','0','10','2','276');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('423','ice-fang','15','65','95','15','0','10','2','275');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('424','fire-fang','10','65','95','15','0','10','2','274');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('425','shadow-sneak','8','40','100','30','1','10','2','104');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('426','mud-bomb','5','65','85','10','0','10','3','74');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('427','psycho-cut','14','70','100','20','0','10','2','44');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('428','zen-headbutt','14','80','90','15','0','10','2','32');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('429','mirror-shot','9','65','85','10','0','10','3','74');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('430','flash-cannon','9','80','100','10','0','10','3','73');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('431','rock-climb','1','90','85','20','0','10','2','77');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('432','defog','3','','','15','0','10','1','259');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('433','trick-room','14','','','5','-7','12','1','260');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('434','draco-meteor','16','130','90','5','0','10','3','205');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('435','discharge','13','80','100','15','0','9','3','7');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('436','lava-plume','10','80','100','15','0','9','3','5');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('437','leaf-storm','12','130','90','5','0','10','3','205');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('438','power-whip','12','120','85','10','0','10','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('439','rock-wrecker','6','150','90','5','0','10','2','81');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('440','cross-poison','4','70','100','20','0','10','2','210');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('441','gunk-shot','4','120','80','5','0','10','2','3');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('442','iron-head','9','80','100','15','0','10','2','32');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('443','magnet-bomb','9','60','','20','0','10','2','18');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('444','stone-edge','6','100','80','5','0','10','2','44');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('445','captivate','1','','100','20','0','11','1','266');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('446','stealth-rock','6','','','20','0','6','1','267');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('447','grass-knot','12','','100','20','0','10','3','197');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('448','chatter','3','65','100','20','0','10','3','268');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('449','judgment','1','100','100','10','0','10','3','269');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('450','bug-bite','7','60','100','20','0','10','2','225');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('451','charge-beam','13','50','90','10','0','10','3','277');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('452','wood-hammer','12','120','100','15','0','10','2','199');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('453','aqua-jet','11','40','100','20','1','10','2','104');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('454','attack-order','7','90','100','15','0','10','2','44');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('455','defend-order','7','','','10','0','7','1','207');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('456','heal-order','7','','','10','0','7','1','33');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('457','head-smash','6','150','80','5','0','10','2','270');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('458','double-hit','1','35','90','10','0','10','2','45');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('459','roar-of-time','16','150','90','5','0','10','3','81');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('460','spacial-rend','16','100','95','5','0','10','3','44');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('461','lunar-dance','14','','','10','0','7','1','271');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('462','crush-grip','1','','100','5','0','10','2','238');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('463','magma-storm','10','100','75','5','0','10','3','43');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('464','dark-void','17','','50','10','0','11','1','2');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('465','seed-flare','12','120','85','5','0','10','3','272');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('466','ominous-wind','8','60','100','5','0','10','3','141');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('467','shadow-force','8','120','100','5','0','10','2','273');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('468','hone-claws','17','','','15','0','7','1','278');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('469','wide-guard','6','','','10','3','4','1','279');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('470','guard-split','14','','','10','0','10','1','280');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('471','power-split','14','','','10','0','10','1','281');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('472','wonder-room','14','','','10','0','12','1','282');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('473','psyshock','14','80','100','10','0','10','3','283');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('474','venoshock','4','65','100','10','0','10','3','284');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('475','autotomize','9','','','15','0','7','1','285');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('476','rage-powder','7','','','20','2','7','1','173');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('477','telekinesis','14','','','15','0','10','1','286');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('478','magic-room','14','','','10','0','12','1','287');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('479','smack-down','6','50','100','15','0','10','2','288');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('480','storm-throw','2','60','100','10','0','10','2','289');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('481','flame-burst','10','70','100','15','0','10','3','290');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('482','sludge-wave','4','95','100','10','0','9','3','3');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('483','quiver-dance','7','','','20','0','7','1','291');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('484','heavy-slam','9','','100','10','0','10','2','292');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('485','synchronoise','14','120','100','10','0','9','3','293');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('486','electro-ball','13','','100','10','0','10','3','294');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('487','soak','11','','100','20','0','10','1','295');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('488','flame-charge','10','50','100','20','0','10','2','296');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('489','coil','4','','','20','0','7','1','323');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('490','low-sweep','2','65','100','20','0','10','2','21');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('491','acid-spray','4','40','100','20','0','10','3','297');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('492','foul-play','17','95','100','15','0','10','2','298');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('493','simple-beam','1','','100','15','0','10','1','299');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('494','entrainment','1','','100','15','0','10','1','300');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('495','after-you','1','','','15','0','10','1','301');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('496','round','1','60','100','15','0','10','3','302');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('497','echoed-voice','1','40','100','15','0','10','3','303');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('498','chip-away','1','70','100','20','0','10','2','304');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('499','clear-smog','4','50','','15','0','10','3','305');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('500','stored-power','14','20','100','10','0','10','3','306');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('501','quick-guard','2','','','15','3','4','1','307');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('502','ally-switch','14','','','15','2','7','1','308');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('503','scald','11','80','100','15','0','10','3','5');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('504','shell-smash','1','','','15','0','7','1','309');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('505','heal-pulse','14','','','10','0','10','1','310');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('506','hex','8','65','100','10','0','10','3','311');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('507','sky-drop','3','60','100','10','0','10','2','312');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('508','shift-gear','9','','','10','0','7','1','313');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('509','circle-throw','2','60','90','10','-6','10','2','314');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('510','incinerate','10','60','100','15','0','11','3','315');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('511','quash','17','','100','15','0','10','1','316');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('512','acrobatics','3','55','100','15','0','10','2','318');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('513','reflect-type','1','','','15','0','10','1','319');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('514','retaliate','1','70','100','5','0','10','2','320');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('515','final-gambit','2','','100','5','0','10','3','321');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('516','bestow','1','','','15','0','10','1','324');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('517','inferno','10','100','50','5','0','10','3','5');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('518','water-pledge','11','80','100','10','0','10','3','325');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('519','fire-pledge','10','80','100','10','0','10','3','326');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('520','grass-pledge','12','80','100','10','0','10','3','327');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('521','volt-switch','13','70','100','20','0','10','3','229');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('522','struggle-bug','7','50','100','20','0','11','3','72');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('523','bulldoze','5','60','100','20','0','9','2','71');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('524','frost-breath','15','60','90','10','0','10','3','289');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('525','dragon-tail','16','60','90','10','-6','10','2','314');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('526','work-up','1','','','30','0','7','1','328');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('527','electroweb','13','55','95','15','0','11','3','21');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('528','wild-charge','13','90','100','15','0','10','2','49');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('529','drill-run','5','80','95','10','0','10','2','44');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('530','dual-chop','16','40','90','15','0','10','2','45');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('531','heart-stamp','14','60','100','25','0','10','2','32');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('532','horn-leech','12','75','100','10','0','10','2','4');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('533','sacred-sword','2','90','100','15','0','10','2','304');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('534','razor-shell','11','75','95','10','0','10','2','70');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('535','heat-crash','10','','100','10','0','10','2','292');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('536','leaf-tornado','12','65','90','10','0','10','3','74');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('537','steamroller','7','65','100','20','0','10','2','151');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('538','cotton-guard','12','','','10','0','7','1','329');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('539','night-daze','17','85','95','10','0','10','3','74');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('540','psystrike','14','100','100','10','0','10','3','283');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('541','tail-slap','1','25','85','10','0','10','2','30');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('542','hurricane','3','110','70','10','0','10','3','334');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('543','head-charge','1','120','100','15','0','10','2','49');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('544','gear-grind','9','50','85','15','0','10','2','45');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('545','searing-shot','10','100','100','5','0','9','3','5');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('546','techno-blast','1','120','100','5','0','10','3','269');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('547','relic-song','1','75','100','10','0','11','3','330');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('548','secret-sword','2','85','100','10','0','10','3','283');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('549','glaciate','15','65','95','10','0','11','3','331');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('550','bolt-strike','13','130','85','5','0','10','2','7');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('551','blue-flare','10','130','85','5','0','10','3','5');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('552','fiery-dance','10','80','100','10','0','10','3','277');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('553','freeze-shock','15','140','90','5','0','10','2','332');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('554','ice-burn','15','140','90','5','0','10','3','333');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('555','snarl','17','55','95','15','0','11','3','72');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('556','icicle-crash','15','85','90','10','0','10','2','32');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('557','v-create','10','180','95','5','0','10','2','335');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('558','fusion-flare','10','100','100','5','0','10','3','336');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('559','fusion-bolt','13','100','100','5','0','10','2','337');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('560','flying-press','2','100','95','10','0','10','2','338');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('561','mat-block','2','','','10','0','4','1','377');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('562','belch','4','120','90','10','0','10','3','339');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('563','rototiller','5','','','10','0','14','1','340');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('564','sticky-web','7','','','20','0','6','1','341');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('565','fell-stinger','7','50','100','25','0','10','2','342');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('566','phantom-force','8','90','100','10','0','10','2','273');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('567','trick-or-treat','8','','100','20','0','10','1','343');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('568','noble-roar','1','','100','30','0','10','1','344');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('569','ion-deluge','13','','','25','1','12','1','345');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('570','parabolic-charge','13','65','100','20','0','9','3','346');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('571','forests-curse','12','','100','20','0','10','1','376');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('572','petal-blizzard','12','90','100','15','0','9','2','379');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('573','freeze-dry','15','70','100','20','0','10','3','380');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('574','disarming-voice','18','40','','15','0','11','3','381');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('575','parting-shot','17','','100','20','0','10','1','347');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('576','topsy-turvy','17','','','20','0','10','1','348');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('577','draining-kiss','18','50','100','10','0','10','3','349');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('578','crafty-shield','18','','','10','3','4','1','350');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('579','flower-shield','18','','','10','0','14','1','351');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('580','grassy-terrain','12','','','10','0','12','1','352');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('581','misty-terrain','18','','','10','0','12','1','353');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('582','electrify','13','','','20','0','10','1','354');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('583','play-rough','18','90','90','10','0','10','2','69');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('584','fairy-wind','18','40','100','30','0','10','3','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('585','moonblast','18','95','100','15','0','10','3','72');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('586','boomburst','1','140','100','10','0','9','3','379');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('587','fairy-lock','18','','','10','0','12','1','355');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('588','kings-shield','9','','','10','4','7','1','356');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('589','play-nice','1','','','20','0','10','1','357');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('590','confide','1','','','20','0','10','1','358');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('591','diamond-storm','6','100','95','5','0','11','2','359');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('592','steam-eruption','11','110','95','5','0','10','3','5');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('593','hyperspace-hole','14','80','','5','0','10','3','360');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('594','water-shuriken','11','15','100','20','1','10','3','361');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('595','mystical-fire','10','75','100','10','0','10','3','72');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('596','spiky-shield','12','','','10','4','7','1','362');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('597','aromatic-mist','18','','','20','0','3','1','363');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('598','eerie-impulse','13','','100','15','0','10','1','62');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('599','venom-drench','4','','100','20','0','11','1','364');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('600','powder','7','','100','20','1','10','1','378');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('601','geomancy','18','','','10','0','7','1','366');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('602','magnetic-flux','13','','','20','0','13','1','367');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('603','happy-hour','1','','','30','0','4','1','368');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('604','electric-terrain','13','','','10','0','12','1','369');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('605','dazzling-gleam','18','80','100','10','0','11','3','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('606','celebrate','1','','','40','0','7','1','370');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('607','hold-hands','1','','','40','0','3','1','371');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('608','baby-doll-eyes','18','','100','30','1','10','1','365');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('609','nuzzle','13','20','100','20','0','10','2','372');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('610','hold-back','1','40','100','40','0','10','2','102');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('611','infestation','7','20','100','20','0','10','3','43');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('612','power-up-punch','2','40','100','20','0','10','2','375');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('613','oblivion-wing','3','80','100','10','0','10','3','349');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('614','thousand-arrows','5','90','100','10','0','11','2','373');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('615','thousand-waves','5','90','100','10','0','11','2','374');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('616','lands-wrath','5','90','100','10','0','11','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('617','light-of-ruin','18','140','90','5','0','10','3','270');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('618','origin-pulse','11','110','85','10','0','11','3','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('619','precipice-blades','5','120','85','10','0','11','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('620','dragon-ascent','3','120','100','5','0','10','2','230');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('621','hyperspace-fury','17','100','','5','0','10','2','360');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('622','breakneck-blitz--physical','1','','','1','0','10','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('623','breakneck-blitz--special','1','','','1','0','10','3','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('624','all-out-pummeling--physical','2','','','1','0','10','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('625','all-out-pummeling--special','2','','','1','0','10','3','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('626','supersonic-skystrike--physical','3','','','1','0','10','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('627','supersonic-skystrike--special','3','','','1','0','10','3','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('628','acid-downpour--physical','4','','','1','0','10','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('629','acid-downpour--special','4','','','1','0','10','3','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('630','tectonic-rage--physical','5','','','1','0','10','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('631','tectonic-rage--special','5','','','1','0','10','3','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('632','continental-crush--physical','6','','','1','0','10','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('633','continental-crush--special','6','','','1','0','10','3','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('634','savage-spin-out--physical','7','','','1','0','10','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('635','savage-spin-out--special','7','','','1','0','10','3','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('636','never-ending-nightmare--physical','8','','','1','0','10','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('637','never-ending-nightmare--special','8','','','1','0','10','3','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('638','corkscrew-crash--physical','9','','','1','0','10','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('639','corkscrew-crash--special','9','','','1','0','10','3','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('640','inferno-overdrive--physical','10','','','1','0','10','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('641','inferno-overdrive--special','10','','','1','0','10','3','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('642','hydro-vortex--physical','11','','','1','0','10','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('643','hydro-vortex--special','11','','','1','0','10','3','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('644','bloom-doom--physical','12','','','1','0','10','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('645','bloom-doom--special','12','','','1','0','10','3','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('646','gigavolt-havoc--physical','13','','','1','0','10','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('647','gigavolt-havoc--special','13','','','1','0','10','3','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('648','shattered-psyche--physical','14','','','1','0','10','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('649','shattered-psyche--special','14','','','1','0','10','3','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('650','subzero-slammer--physical','15','','','1','0','10','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('651','subzero-slammer--special','15','','','1','0','10','3','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('652','devastating-drake--physical','16','','','1','0','10','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('653','devastating-drake--special','16','','','1','0','10','3','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('654','black-hole-eclipse--physical','17','','','1','0','10','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('655','black-hole-eclipse--special','17','','','1','0','10','3','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('656','twinkle-tackle--physical','18','','','1','0','10','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('657','twinkle-tackle--special','18','','','1','0','10','3','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('658','catastropika','13','210','','1','0','10','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('659','shore-up','5','','','10','0','7','1','382');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('660','first-impression','7','90','100','10','2','10','2','383');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('661','baneful-bunker','4','','','10','4','7','1','384');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('662','spirit-shackle','8','80','100','10','0','10','2','385');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('663','darkest-lariat','17','85','100','10','0','10','2','304');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('664','sparkling-aria','11','90','100','10','0','9','3','386');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('665','ice-hammer','15','100','90','10','0','10','2','219');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('666','floral-healing','18','','','10','0','10','1','387');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('667','high-horsepower','5','95','95','10','0','10','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('668','strength-sap','12','','100','10','0','10','1','388');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('669','solar-blade','12','125','100','10','0','10','2','152');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('670','leafage','12','40','100','40','0','10','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('671','spotlight','1','','','15','3','10','1','389');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('672','toxic-thread','4','','100','20','0','10','1','390');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('673','laser-focus','1','','','30','0','7','1','391');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('674','gear-up','9','','','20','0','13','1','392');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('675','throat-chop','17','80','100','15','0','10','2','393');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('676','pollen-puff','7','90','100','15','0','10','3','394');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('677','anchor-shot','9','80','100','20','0','10','2','385');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('678','psychic-terrain','14','','','10','0','12','1','395');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('679','lunge','7','80','100','15','0','10','2','396');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('680','fire-lash','10','80','100','15','0','10','2','397');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('681','power-trip','17','20','100','10','0','10','2','306');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('682','burn-up','10','130','100','5','0','10','3','398');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('683','speed-swap','14','','','10','0','10','1','399');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('684','smart-strike','9','70','','10','0','10','2','18');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('685','purify','4','','','20','0','10','1','400');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('686','revelation-dance','1','90','100','15','0','10','3','401');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('687','core-enforcer','16','100','100','10','0','11','3','402');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('688','trop-kick','12','70','100','15','0','10','2','396');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('689','instruct','14','','','15','0','10','1','403');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('690','beak-blast','3','100','100','15','-3','10','2','404');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('691','clanging-scales','16','110','100','5','0','11','3','405');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('692','dragon-hammer','16','90','100','15','0','10','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('693','brutal-swing','17','60','100','20','0','9','2','406');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('694','aurora-veil','15','','','20','0','4','1','407');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('695','sinister-arrow-raid','8','180','','1','0','10','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('696','malicious-moonsault','17','180','','1','0','10','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('697','oceanic-operetta','11','195','','1','0','10','3','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('698','guardian-of-alola','18','','','1','0','10','3','413');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('699','soul-stealing-7-star-strike','8','195','','1','0','10','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('700','stoked-sparksurfer','13','175','','1','0','10','3','7');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('701','pulverizing-pancake','1','210','','1','0','10','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('702','extreme-evoboost','1','','','1','0','7','1','414');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('703','genesis-supernova','14','185','','1','0','10','3','415');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('704','shell-trap','10','150','100','5','-3','11','3','408');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('705','fleur-cannon','18','130','90','5','0','10','3','205');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('706','psychic-fangs','14','85','100','10','0','10','2','187');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('707','stomping-tantrum','5','75','100','10','0','10','2','409');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('708','shadow-bone','8','85','100','10','0','10','2','70');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('709','accelerock','6','40','100','20','1','10','2','104');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('710','liquidation','11','85','100','10','0','10','2','70');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('711','prismatic-laser','14','160','100','10','0','10','3','81');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('712','spectral-thief','8','90','100','10','0','10','2','410');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('713','sunsteel-strike','9','100','100','5','0','10','2','411');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('714','moongeist-beam','8','100','100','5','0','10','3','411');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('715','tearful-look','1','','','20','0','10','1','412');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('716','zing-zap','13','80','100','10','0','10','2','32');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('717','natures-madness','18','','90','10','0','10','3','41');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('718','multi-attack','1','120','100','10','0','10','2','269');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('719','10-000-000-volt-thunderbolt','13','195','','1','0','10','3','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('720','mind-blown','10','150','100','5','0','9','3','420');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('721','plasma-fists','13','100','100','15','0','10','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('722','photon-geyser','14','100','100','5','0','10','3','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('723','light-that-burns-the-sky','14','200','','1','0','10','3','416');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('724','searing-sunraze-smash','9','200','','1','0','10','2','411');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('725','menacing-moonraze-maelstrom','8','200','','1','0','10','3','411');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('726','lets-snuggle-forever','18','190','','1','0','10','2','417');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('727','splintered-stormshards','6','190','','1','0','10','2','418');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('728','clangorous-soulblaze','16','185','','1','0','11','3','419');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('729','zippy-zap','13','80','100','10','2','10','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('730','splishy-splash','11','90','100','15','0','11','3','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('731','floaty-fall','3','90','95','15','0','10','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('732','pika-papow','13','','','20','0','10','3','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('733','bouncy-bubble','11','60','100','20','0','10','3','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('734','buzzy-buzz','13','60','100','20','0','10','3','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('735','sizzly-slide','10','60','100','20','0','10','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('736','glitzy-glow','14','80','95','15','0','10','3','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('737','baddy-bad','17','80','95','15','0','10','3','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('738','sappy-seed','12','100','90','10','0','10','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('739','freezy-frost','15','100','90','10','0','10','3','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('740','sparkly-swirl','18','120','85','5','0','10','3','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('741','veevee-volley','1','','','20','0','10','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('742','double-iron-bash','9','60','100','5','0','10','2','45');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('743','max-guard','1','','','10','4','7','1','112');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('744','dynamax-cannon','16','100','100','5','0','10','3','421');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('745','snipe-shot','11','80','100','15','0','10','3','422');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('746','jaw-lock','17','80','100','10','0','10','2','423');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('747','stuff-cheeks','1','','','10','0','7','1','424');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('748','no-retreat','2','','','5','0','7','1','425');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('749','tar-shot','6','','100','15','0','10','1','426');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('750','magic-powder','14','','100','20','0','10','1','427');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('751','dragon-darts','16','50','100','10','0','10','2','428');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('752','teatime','1','','','10','0','14','1','429');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('753','octolock','2','','100','15','0','10','1','430');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('754','bolt-beak','13','85','100','10','0','10','2','431');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('755','fishious-rend','11','85','100','10','0','10','2','431');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('756','court-change','1','','100','10','0','12','1','432');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('757','max-flare','10','100','','10','0','2','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('758','max-flutterby','7','10','','10','0','2','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('759','max-lightning','13','10','','10','0','2','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('760','max-strike','1','10','','10','0','2','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('761','max-knuckle','2','10','','10','0','2','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('762','max-phantasm','8','10','','10','0','2','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('763','max-hailstorm','15','10','','10','0','2','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('764','max-ooze','4','10','','10','0','2','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('765','max-geyser','11','10','','10','0','2','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('766','max-airstream','3','10','','10','0','2','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('767','max-starfall','18','10','','10','0','2','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('768','max-wyrmwind','16','10','','10','0','2','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('769','max-mindstorm','14','10','','10','0','2','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('770','max-rockfall','6','10','','10','0','2','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('771','max-quake','5','10','','10','0','2','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('772','max-darkness','17','10','','10','0','2','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('773','max-overgrowth','12','10','','10','0','2','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('774','max-steelspike','9','10','','10','0','2','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('775','clangorous-soul','16','','100','5','0','7','1','433');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('776','body-press','2','80','100','10','0','10','2','434');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('777','decorate','18','','','15','0','10','1','435');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('778','drum-beating','12','80','100','10','0','10','2','71');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('779','snap-trap','12','35','100','15','0','10','2','43');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('780','pyro-ball','10','120','90','5','0','10','2','5');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('781','behemoth-blade','9','100','100','5','0','10','2','436');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('782','behemoth-bash','9','100','100','5','0','10','2','436');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('783','aura-wheel','13','110','100','10','0','10','2','437');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('784','breaking-swipe','16','60','100','15','0','11','2','396');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('785','branch-poke','12','40','100','40','0','10','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('786','overdrive','13','80','100','10','0','11','3','439');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('787','apple-acid','12','80','100','10','0','10','3','440');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('788','grav-apple','12','80','100','10','0','10','2','397');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('789','spirit-break','18','75','100','15','0','10','2','72');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('790','strange-steam','18','90','95','10','0','10','3','77');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('791','life-dew','11','','','10','0','13','1','441');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('792','obstruct','17','','100','10','4','7','1','442');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('793','false-surrender','17','80','','10','0','10','2','18');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('794','meteor-assault','2','150','100','5','0','10','2','81');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('795','eternabeam','16','160','90','5','0','10','3','81');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('796','steel-beam','9','140','95','5','0','10','3','420');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('797','expanding-force','14','80','100','10','0','10','3','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('798','steel-roller','9','130','100','5','0','10','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('799','scale-shot','16','25','90','20','0','10','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('800','meteor-beam','6','120','90','10','0','10','3','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('801','shell-side-arm','4','90','100','10','0','10','3','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('802','misty-explosion','18','100','100','5','0','9','3','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('803','grassy-glide','12','70','100','20','0','10','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('804','rising-voltage','13','70','100','20','0','10','3','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('805','terrain-pulse','1','50','100','10','0','10','3','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('806','skitter-smack','7','70','90','10','0','10','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('807','burning-jealousy','10','70','100','5','0','11','3','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('808','lash-out','17','75','100','5','0','10','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('809','poltergeist','8','110','90','5','0','10','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('810','corrosive-gas','4','','100','40','0','9','1','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('811','coaching','2','','','10','0','13','1','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('812','flip-turn','11','60','100','20','0','10','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('813','triple-axel','15','20','90','10','0','10','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('814','dual-wingbeat','3','40','90','10','0','10','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('815','scorching-sands','5','70','100','10','0','10','3','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('816','jungle-healing','12','','','10','0','13','1','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('817','wicked-blow','17','80','100','5','0','10','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('818','surging-strikes','11','25','100','5','0','10','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('819','thunder-cage','13','80','90','15','0','10','3','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('820','dragon-energy','16','150','100','5','0','11','3','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('821','freezing-glare','14','90','100','10','0','10','3','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('822','fiery-wrath','17','90','100','10','0','11','3','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('823','thunderous-kick','2','90','100','10','0','10','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('824','glacial-lance','15','130','100','5','0','11','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('825','astral-barrage','8','120','100','5','0','11','3','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('826','eerie-spell','14','80','100','5','0','10','3','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('10001','shadow-rush','10002','55','100','','0','10','2','10001');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('10002','shadow-blast','10002','80','100','','0','10','2','44');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('10003','shadow-blitz','10002','40','100','','0','10','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('10004','shadow-bolt','10002','75','100','','0','10','3','7');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('10005','shadow-break','10002','75','100','','0','10','2','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('10006','shadow-chill','10002','75','100','','0','10','3','6');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('10007','shadow-end','10002','120','60','','0','10','2','10002');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('10008','shadow-fire','10002','75','100','','0','10','3','5');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('10009','shadow-rave','10002','70','100','','0','6','3','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('10010','shadow-storm','10002','95','100','','0','6','3','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('10011','shadow-wave','10002','50','100','','0','6','3','1');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('10012','shadow-down','10002','','100','','0','6','1','60');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('10013','shadow-half','10002','','100','','0','12','3','10003');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('10014','shadow-hold','10002','','','','0','6','1','107');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('10015','shadow-mist','10002','','100','','0','6','1','10004');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('10016','shadow-panic','10002','','90','','0','6','1','50');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('10017','shadow-shed','10002','','','','0','12','1','10005');
insert into moves (id,name,type_id,power,accuracy,pp,priority,target,damage_class,description) values('10018','shadow-sky','10002','','','','0','12','1','10006');

-- abilities
INSERT INTO abilities (id,name,is_main_series) VALUES ('1','stench','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('2','drizzle','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('3','speed-boost','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('4','battle-armor','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('5','sturdy','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('6','damp','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('7','limber','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('8','sand-veil','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('9','static','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('10','volt-absorb','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('11','water-absorb','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('12','oblivious','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('13','cloud-nine','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('14','compound-eyes','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('15','insomnia','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('16','color-change','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('17','immunity','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('18','flash-fire','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('19','shield-dust','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('20','own-tempo','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('21','suction-cups','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('22','intimidate','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('23','shadow-tag','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('24','rough-skin','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('25','wonder-guard','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('26','levitate','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('27','effect-spore','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('28','synchronize','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('29','clear-body','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('30','natural-cure','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('31','lightning-rod','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('32','serene-grace','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('33','swift-swim','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('34','chlorophyll','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('35','illuminate','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('36','trace','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('37','huge-power','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('38','poison-point','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('39','inner-focus','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('40','magma-armor','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('41','water-veil','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('42','magnet-pull','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('43','soundproof','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('44','rain-dish','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('45','sand-stream','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('46','pressure','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('47','thick-fat','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('48','early-bird','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('49','flame-body','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('50','run-away','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('51','keen-eye','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('52','hyper-cutter','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('53','pickup','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('54','truant','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('55','hustle','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('56','cute-charm','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('57','plus','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('58','minus','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('59','forecast','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('60','sticky-hold','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('61','shed-skin','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('62','guts','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('63','marvel-scale','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('64','liquid-ooze','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('65','overgrow','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('66','blaze','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('67','torrent','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('68','swarm','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('69','rock-head','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('70','drought','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('71','arena-trap','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('72','vital-spirit','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('73','white-smoke','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('74','pure-power','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('75','shell-armor','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('76','air-lock','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('77','tangled-feet','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('78','motor-drive','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('79','rivalry','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('80','steadfast','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('81','snow-cloak','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('82','gluttony','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('83','anger-point','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('84','unburden','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('85','heatproof','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('86','simple','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('87','dry-skin','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('88','download','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('89','iron-fist','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('90','poison-heal','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('91','adaptability','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('92','skill-link','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('93','hydration','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('94','solar-power','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('95','quick-feet','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('96','normalize','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('97','sniper','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('98','magic-guard','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('99','no-guard','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('100','stall','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('101','technician','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('102','leaf-guard','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('103','klutz','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('104','mold-breaker','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('105','super-luck','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('106','aftermath','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('107','anticipation','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('108','forewarn','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('109','unaware','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('110','tinted-lens','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('111','filter','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('112','slow-start','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('113','scrappy','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('114','storm-drain','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('115','ice-body','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('116','solid-rock','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('117','snow-warning','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('118','honey-gather','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('119','frisk','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('120','reckless','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('121','multitype','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('122','flower-gift','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('123','bad-dreams','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('124','pickpocket','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('125','sheer-force','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('126','contrary','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('127','unnerve','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('128','defiant','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('129','defeatist','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('130','cursed-body','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('131','healer','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('132','friend-guard','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('133','weak-armor','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('134','heavy-metal','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('135','light-metal','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('136','multiscale','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('137','toxic-boost','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('138','flare-boost','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('139','harvest','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('140','telepathy','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('141','moody','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('142','overcoat','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('143','poison-touch','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('144','regenerator','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('145','big-pecks','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('146','sand-rush','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('147','wonder-skin','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('148','analytic','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('149','illusion','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('150','imposter','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('151','infiltrator','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('152','mummy','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('153','moxie','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('154','justified','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('155','rattled','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('156','magic-bounce','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('157','sap-sipper','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('158','prankster','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('159','sand-force','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('160','iron-barbs','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('161','zen-mode','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('162','victory-star','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('163','turboblaze','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('164','teravolt','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('165','aroma-veil','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('166','flower-veil','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('167','cheek-pouch','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('168','protean','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('169','fur-coat','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('170','magician','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('171','bulletproof','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('172','competitive','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('173','strong-jaw','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('174','refrigerate','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('175','sweet-veil','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('176','stance-change','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('177','gale-wings','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('178','mega-launcher','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('179','grass-pelt','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('180','symbiosis','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('181','tough-claws','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('182','pixilate','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('183','gooey','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('184','aerilate','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('185','parental-bond','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('186','dark-aura','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('187','fairy-aura','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('188','aura-break','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('189','primordial-sea','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('190','desolate-land','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('191','delta-stream','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('192','stamina','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('193','wimp-out','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('194','emergency-exit','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('195','water-compaction','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('196','merciless','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('197','shields-down','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('198','stakeout','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('199','water-bubble','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('200','steelworker','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('201','berserk','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('202','slush-rush','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('203','long-reach','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('204','liquid-voice','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('205','triage','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('206','galvanize','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('207','surge-surfer','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('208','schooling','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('209','disguise','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('210','battle-bond','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('211','power-construct','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('212','corrosion','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('213','comatose','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('214','queenly-majesty','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('215','innards-out','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('216','dancer','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('217','battery','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('218','fluffy','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('219','dazzling','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('220','soul-heart','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('221','tangling-hair','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('222','receiver','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('223','power-of-alchemy','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('224','beast-boost','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('225','rks-system','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('226','electric-surge','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('227','psychic-surge','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('228','misty-surge','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('229','grassy-surge','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('230','full-metal-body','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('231','shadow-shield','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('232','prism-armor','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('233','neuroforce','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('234','intrepid-sword','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('235','dauntless-shield','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('236','libero','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('237','ball-fetch','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('238','cotton-down','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('239','propeller-tail','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('240','mirror-armor','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('241','gulp-missile','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('242','stalwart','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('243','steam-engine','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('244','punk-rock','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('245','sand-spit','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('246','ice-scales','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('247','ripen','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('248','ice-face','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('249','power-spot','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('250','mimicry','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('251','screen-cleaner','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('252','steely-spirit','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('253','perish-body','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('254','wandering-spirit','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('255','gorilla-tactics','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('256','neutralizing-gas','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('257','pastel-veil','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('258','hunger-switch','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('259','quick-draw','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('260','unseen-fist','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('261','curious-medicine','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('262','transistor','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('263','dragons-maw','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('264','chilling-neigh','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('265','grim-neigh','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('266','as-one-glastrier','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('267','as-one-spectrier','1');
INSERT INTO abilities (id,name,is_main_series) VALUES ('10001','mountaineer','0');
INSERT INTO abilities (id,name,is_main_series) VALUES ('10002','wave-rider','0');
INSERT INTO abilities (id,name,is_main_series) VALUES ('10003','skater','0');
INSERT INTO abilities (id,name,is_main_series) VALUES ('10004','thrust','0');
INSERT INTO abilities (id,name,is_main_series) VALUES ('10005','perception','0');
INSERT INTO abilities (id,name,is_main_series) VALUES ('10006','parry','0');
INSERT INTO abilities (id,name,is_main_series) VALUES ('10007','instinct','0');
INSERT INTO abilities (id,name,is_main_series) VALUES ('10008','dodge','0');
INSERT INTO abilities (id,name,is_main_series) VALUES ('10009','jagged-edge','0');
INSERT INTO abilities (id,name,is_main_series) VALUES ('10010','frostbite','0');
INSERT INTO abilities (id,name,is_main_series) VALUES ('10011','tenacity','0');
INSERT INTO abilities (id,name,is_main_series) VALUES ('10012','pride','0');
INSERT INTO abilities (id,name,is_main_series) VALUES ('10013','deep-sleep','0');
INSERT INTO abilities (id,name,is_main_series) VALUES ('10014','power-nap','0');
INSERT INTO abilities (id,name,is_main_series) VALUES ('10015','spirit','0');
INSERT INTO abilities (id,name,is_main_series) VALUES ('10016','warm-blanket','0');
INSERT INTO abilities (id,name,is_main_series) VALUES ('10017','gulp','0');
INSERT INTO abilities (id,name,is_main_series) VALUES ('10018','herbivore','0');
INSERT INTO abilities (id,name,is_main_series) VALUES ('10019','sandpit','0');
INSERT INTO abilities (id,name,is_main_series) VALUES ('10020','hot-blooded','0');
INSERT INTO abilities (id,name,is_main_series) VALUES ('10021','medic','0');
INSERT INTO abilities (id,name,is_main_series) VALUES ('10022','life-force','0');
INSERT INTO abilities (id,name,is_main_series) VALUES ('10023','lunchbox','0');
INSERT INTO abilities (id,name,is_main_series) VALUES ('10024','nurse','0');
INSERT INTO abilities (id,name,is_main_series) VALUES ('10025','melee','0');
INSERT INTO abilities (id,name,is_main_series) VALUES ('10026','sponge','0');
INSERT INTO abilities (id,name,is_main_series) VALUES ('10027','bodyguard','0');
INSERT INTO abilities (id,name,is_main_series) VALUES ('10028','hero','0');
INSERT INTO abilities (id,name,is_main_series) VALUES ('10029','last-bastion','0');
INSERT INTO abilities (id,name,is_main_series) VALUES ('10030','stealth','0');
INSERT INTO abilities (id,name,is_main_series) VALUES ('10031','vanguard','0');
INSERT INTO abilities (id,name,is_main_series) VALUES ('10032','nomad','0');
INSERT INTO abilities (id,name,is_main_series) VALUES ('10033','sequence','0');
INSERT INTO abilities (id,name,is_main_series) VALUES ('10034','grass-cloak','0');
INSERT INTO abilities (id,name,is_main_series) VALUES ('10035','celebrate','0');
INSERT INTO abilities (id,name,is_main_series) VALUES ('10036','lullaby','0');
INSERT INTO abilities (id,name,is_main_series) VALUES ('10037','calming','0');
INSERT INTO abilities (id,name,is_main_series) VALUES ('10038','daze','0');
INSERT INTO abilities (id,name,is_main_series) VALUES ('10039','frighten','0');
INSERT INTO abilities (id,name,is_main_series) VALUES ('10040','interference','0');
INSERT INTO abilities (id,name,is_main_series) VALUES ('10041','mood-maker','0');
INSERT INTO abilities (id,name,is_main_series) VALUES ('10042','confidence','0');
INSERT INTO abilities (id,name,is_main_series) VALUES ('10043','fortune','0');
INSERT INTO abilities (id,name,is_main_series) VALUES ('10044','bonanza','0');
INSERT INTO abilities (id,name,is_main_series) VALUES ('10045','explode','0');
INSERT INTO abilities (id,name,is_main_series) VALUES ('10046','omnipotent','0');
INSERT INTO abilities (id,name,is_main_series) VALUES ('10047','share','0');
INSERT INTO abilities (id,name,is_main_series) VALUES ('10048','black-hole','0');
INSERT INTO abilities (id,name,is_main_series) VALUES ('10049','shadow-dash','0');
INSERT INTO abilities (id,name,is_main_series) VALUES ('10050','sprint','0');
INSERT INTO abilities (id,name,is_main_series) VALUES ('10051','disgust','0');
INSERT INTO abilities (id,name,is_main_series) VALUES ('10052','high-rise','0');
INSERT INTO abilities (id,name,is_main_series) VALUES ('10053','climber','0');
INSERT INTO abilities (id,name,is_main_series) VALUES ('10054','flame-boost','0');
INSERT INTO abilities (id,name,is_main_series) VALUES ('10055','aqua-boost','0');
INSERT INTO abilities (id,name,is_main_series) VALUES ('10056','run-up','0');
INSERT INTO abilities (id,name,is_main_series) VALUES ('10057','conqueror','0');
INSERT INTO abilities (id,name,is_main_series) VALUES ('10058','shackle','0');
INSERT INTO abilities (id,name,is_main_series) VALUES ('10059','decoy','0');
INSERT INTO abilities (id,name,is_main_series) VALUES ('10060','shield','0');

-- egg_groups
INSERT INTO egg_groups (id,name) VALUES ('1','monster');
INSERT INTO egg_groups (id,name) VALUES ('2','water1');
INSERT INTO egg_groups (id,name) VALUES ('3','bug');
INSERT INTO egg_groups (id,name) VALUES ('4','flying');
INSERT INTO egg_groups (id,name) VALUES ('5','ground');
INSERT INTO egg_groups (id,name) VALUES ('6','fairy');
INSERT INTO egg_groups (id,name) VALUES ('7','plant');
INSERT INTO egg_groups (id,name) VALUES ('8','humanshape');
INSERT INTO egg_groups (id,name) VALUES ('9','water3');
INSERT INTO egg_groups (id,name) VALUES ('10','mineral');
INSERT INTO egg_groups (id,name) VALUES ('11','indeterminate');
INSERT INTO egg_groups (id,name) VALUES ('12','water2');
INSERT INTO egg_groups (id,name) VALUES ('13','ditto');
INSERT INTO egg_groups (id,name) VALUES ('14','dragon');
INSERT INTO egg_groups (id,name) VALUES ('15','no-eggs');

-- go_moves (type)
-- exp_level_thresholds
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','1','0');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','2','10');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','3','33');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','4','80');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','5','156');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','6','270');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','7','428');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','8','640');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','9','911');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','10','1250');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','11','1663');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','12','2160');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','13','2746');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','14','3430');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','15','4218');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','16','5120');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','17','6141');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','18','7290');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','19','8573');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','20','10000');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','21','11576');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','22','13310');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','23','15208');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','24','17280');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','25','19531');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','26','21970');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','27','24603');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','28','27440');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','29','30486');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','30','33750');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','31','37238');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','32','40960');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','33','44921');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','34','49130');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','35','53593');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','36','58320');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','37','63316');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','38','68590');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','39','74148');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','40','80000');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','41','86151');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','42','92610');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','43','99383');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','44','106480');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','45','113906');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','46','121670');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','47','129778');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','48','138240');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','49','147061');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','50','156250');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','51','165813');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','52','175760');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','53','186096');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','54','196830');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','55','207968');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','56','219520');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','57','231491');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','58','243890');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','59','256723');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','60','270000');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','61','283726');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','62','297910');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','63','312558');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','64','327680');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','65','343281');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','66','359370');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','67','375953');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','68','393040');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','69','410636');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','70','428750');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','71','447388');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','72','466560');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','73','486271');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','74','506530');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','75','527343');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','76','548720');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','77','570666');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','78','593190');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','79','616298');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','80','640000');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','81','664301');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','82','689210');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','83','714733');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','84','740880');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','85','767656');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','86','795070');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','87','823128');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','88','851840');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','89','881211');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','90','911250');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','91','941963');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','92','973360');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','93','1005446');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','94','1038230');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','95','1071718');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','96','1105920');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','97','1140841');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','98','1176490');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','99','1212873');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('1','100','1250000');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','1','0');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','2','8');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','3','27');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','4','64');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','5','125');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','6','216');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','7','343');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','8','512');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','9','729');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','10','1000');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','11','1331');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','12','1728');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','13','2197');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','14','2744');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','15','3375');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','16','4096');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','17','4913');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','18','5832');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','19','6859');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','20','8000');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','21','9261');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','22','10648');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','23','12167');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','24','13824');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','25','15625');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','26','17576');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','27','19683');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','28','21952');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','29','24389');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','30','27000');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','31','29791');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','32','32768');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','33','35937');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','34','39304');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','35','42875');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','36','46656');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','37','50653');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','38','54872');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','39','59319');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','40','64000');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','41','68921');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','42','74088');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','43','79507');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','44','85184');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','45','91125');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','46','97336');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','47','103823');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','48','110592');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','49','117649');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','50','125000');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','51','132651');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','52','140608');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','53','148877');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','54','157464');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','55','166375');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','56','175616');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','57','185193');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','58','195112');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','59','205379');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','60','216000');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','61','226981');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','62','238328');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','63','250047');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','64','262144');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','65','274625');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','66','287496');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','67','300763');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','68','314432');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','69','328509');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','70','343000');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','71','357911');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','72','373248');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','73','389017');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','74','405224');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','75','421875');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','76','438976');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','77','456533');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','78','474552');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','79','493039');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','80','512000');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','81','531441');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','82','551368');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','83','571787');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','84','592704');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','85','614125');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','86','636056');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','87','658503');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','88','681472');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','89','704969');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','90','729000');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','91','753571');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','92','778688');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','93','804357');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','94','830584');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','95','857375');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','96','884736');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','97','912673');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','98','941192');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','99','970299');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('2','100','1000000');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','1','0');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','2','6');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','3','21');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','4','51');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','5','100');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','6','172');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','7','274');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','8','409');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','9','583');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','10','800');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','11','1064');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','12','1382');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','13','1757');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','14','2195');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','15','2700');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','16','3276');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','17','3930');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','18','4665');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','19','5487');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','20','6400');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','21','7408');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','22','8518');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','23','9733');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','24','11059');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','25','12500');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','26','14060');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','27','15746');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','28','17561');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','29','19511');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','30','21600');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','31','23832');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','32','26214');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','33','28749');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','34','31443');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','35','34300');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','36','37324');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','37','40522');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','38','43897');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','39','47455');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','40','51200');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','41','55136');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','42','59270');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','43','63605');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','44','68147');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','45','72900');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','46','77868');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','47','83058');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','48','88473');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','49','94119');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','50','100000');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','51','106120');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','52','112486');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','53','119101');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','54','125971');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','55','133100');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','56','140492');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','57','148154');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','58','156089');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','59','164303');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','60','172800');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','61','181584');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','62','190662');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','63','200037');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','64','209715');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','65','219700');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','66','229996');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','67','240610');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','68','251545');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','69','262807');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','70','274400');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','71','286328');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','72','298598');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','73','311213');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','74','324179');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','75','337500');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','76','351180');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','77','365226');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','78','379641');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','79','394431');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','80','409600');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','81','425152');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','82','441094');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','83','457429');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','84','474163');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','85','491300');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','86','508844');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','87','526802');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','88','545177');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','89','563975');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','90','583200');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','91','602856');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','92','622950');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','93','643485');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','94','664467');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','95','685900');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','96','707788');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','97','730138');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','98','752953');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','99','776239');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('3','100','800000');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','1','0');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','2','9');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','3','57');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','4','96');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','5','135');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','6','179');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','7','236');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','8','314');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','9','419');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','10','560');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','11','742');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','12','973');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','13','1261');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','14','1612');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','15','2035');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','16','2535');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','17','3120');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','18','3798');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','19','4575');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','20','5460');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','21','6458');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','22','7577');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','23','8825');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','24','10208');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','25','11735');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','26','13411');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','27','15244');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','28','17242');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','29','19411');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','30','21760');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','31','24294');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','32','27021');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','33','29949');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','34','33084');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','35','36435');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','36','40007');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','37','43808');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','38','47846');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','39','52127');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','40','56660');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','41','61450');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','42','66505');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','43','71833');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','44','77440');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','45','83335');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','46','89523');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','47','96012');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','48','102810');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','49','109923');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','50','117360');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','51','125126');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','52','133229');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','53','141677');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','54','150476');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','55','159635');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','56','169159');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','57','179056');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','58','189334');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','59','199999');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','60','211060');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','61','222522');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','62','234393');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','63','246681');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','64','259392');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','65','272535');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','66','286115');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','67','300140');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','68','314618');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','69','329555');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','70','344960');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','71','360838');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','72','377197');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','73','394045');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','74','411388');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','75','429235');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','76','447591');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','77','466464');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','78','485862');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','79','505791');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','80','526260');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','81','547274');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','82','568841');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','83','590969');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','84','613664');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','85','636935');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','86','660787');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','87','685228');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','88','710266');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','89','735907');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','90','762160');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','91','789030');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','92','816525');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','93','844653');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','94','873420');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','95','902835');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','96','932903');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','97','963632');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','98','995030');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','99','1027103');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('4','100','1059860');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','1','0');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','2','15');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','3','52');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','4','122');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','5','237');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','6','406');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','7','637');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','8','942');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','9','1326');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','10','1800');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','11','2369');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','12','3041');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','13','3822');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','14','4719');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','15','5737');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','16','6881');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','17','8155');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','18','9564');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','19','11111');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','20','12800');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','21','14632');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','22','16610');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','23','18737');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','24','21012');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','25','23437');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','26','26012');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','27','28737');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','28','31610');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','29','34632');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','30','37800');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','31','41111');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','32','44564');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','33','48155');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','34','51881');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','35','55737');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','36','59719');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','37','63822');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','38','68041');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','39','72369');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','40','76800');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','41','81326');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','42','85942');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','43','90637');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','44','95406');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','45','100237');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','46','105122');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','47','110052');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','48','115015');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','49','120001');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','50','125000');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','51','131324');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','52','137795');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','53','144410');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','54','151165');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','55','158056');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','56','165079');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','57','172229');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','58','179503');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','59','186894');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','60','194400');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','61','202013');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','62','209728');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','63','217540');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','64','225443');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','65','233431');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','66','241496');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','67','249633');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','68','257834');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','69','267406');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','70','276458');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','71','286328');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','72','296358');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','73','305767');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','74','316074');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','75','326531');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','76','336255');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','77','346965');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','78','357812');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','79','367807');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','80','378880');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','81','390077');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','82','400293');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','83','411686');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','84','423190');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','85','433572');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','86','445239');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','87','457001');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','88','467489');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','89','479378');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','90','491346');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','91','501878');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','92','513934');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','93','526049');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','94','536557');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','95','548720');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','96','560922');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','97','571333');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','98','583539');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','99','591882');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('5','100','600000');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','1','0');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','2','4');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','3','13');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','4','32');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','5','65');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','6','112');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','7','178');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','8','276');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','9','393');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','10','540');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','11','745');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','12','967');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','13','1230');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','14','1591');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','15','1957');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','16','2457');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','17','3046');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','18','3732');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','19','4526');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','20','5440');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','21','6482');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','22','7666');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','23','9003');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','24','10506');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','25','12187');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','26','14060');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','27','16140');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','28','18439');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','29','20974');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','30','23760');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','31','26811');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','32','30146');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','33','33780');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','34','37731');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','35','42017');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','36','46656');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','37','50653');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','38','55969');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','39','60505');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','40','66560');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','41','71677');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','42','78533');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','43','84277');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','44','91998');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','45','98415');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','46','107069');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','47','114205');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','48','123863');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','49','131766');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','50','142500');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','51','151222');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','52','163105');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','53','172697');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','54','185807');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','55','196322');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','56','210739');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','57','222231');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','58','238036');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','59','250562');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','60','267840');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','61','281456');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','62','300293');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','63','315059');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','64','335544');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','65','351520');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','66','373744');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','67','390991');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','68','415050');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','69','433631');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','70','459620');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','71','479600');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','72','507617');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','73','529063');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','74','559209');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','75','582187');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','76','614566');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','77','639146');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','78','673863');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','79','700115');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','80','737280');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','81','765275');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','82','804997');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','83','834809');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','84','877201');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','85','908905');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','86','954084');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','87','987754');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','88','1035837');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','89','1071552');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','90','1122660');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','91','1160499');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','92','1214753');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','93','1254796');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','94','1312322');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','95','1354652');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','96','1415577');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','97','1460276');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','98','1524731');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','99','1571884');
INSERT INTO exp_level_thresholds (level_group,level,exp_threshold) VALUES ('6','100','1640000');

-- type_effectiveness (type)
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('1','1','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('1','2','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('1','3','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('1','4','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('1','5','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('1','6','50');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('1','7','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('1','8','0');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('1','9','50');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('1','10','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('1','11','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('1','12','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('1','13','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('1','14','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('1','15','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('1','16','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('1','17','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('1','18','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('2','1','200');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('2','2','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('2','3','50');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('2','4','50');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('2','5','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('2','6','200');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('2','7','50');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('2','8','0');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('2','9','200');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('2','10','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('2','11','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('2','12','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('2','13','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('2','14','50');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('2','15','200');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('2','16','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('2','17','200');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('2','18','50');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('3','1','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('3','2','200');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('3','3','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('3','4','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('3','5','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('3','6','50');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('3','7','200');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('3','8','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('3','9','50');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('3','10','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('3','11','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('3','12','200');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('3','13','50');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('3','14','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('3','15','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('3','16','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('3','17','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('3','18','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('4','1','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('4','2','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('4','3','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('4','4','50');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('4','5','50');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('4','6','50');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('4','7','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('4','8','50');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('4','9','0');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('4','10','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('4','11','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('4','12','200');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('4','13','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('4','14','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('4','15','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('4','16','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('4','17','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('4','18','200');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('5','1','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('5','2','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('5','3','0');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('5','4','200');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('5','5','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('5','6','200');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('5','7','50');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('5','8','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('5','9','200');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('5','10','200');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('5','11','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('5','12','50');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('5','13','200');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('5','14','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('5','15','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('5','16','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('5','17','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('5','18','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('6','1','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('6','2','50');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('6','3','200');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('6','4','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('6','5','50');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('6','6','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('6','7','200');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('6','8','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('6','9','50');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('6','10','200');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('6','11','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('6','12','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('6','13','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('6','14','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('6','15','200');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('6','16','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('6','17','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('6','18','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('7','1','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('7','2','50');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('7','3','50');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('7','4','50');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('7','5','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('7','6','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('7','7','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('7','8','50');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('7','9','50');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('7','10','50');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('7','11','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('7','12','200');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('7','13','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('7','14','200');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('7','15','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('7','16','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('7','17','200');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('7','18','50');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('8','1','0');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('8','2','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('8','3','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('8','4','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('8','5','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('8','6','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('8','7','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('8','8','200');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('8','9','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('8','10','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('8','11','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('8','12','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('8','13','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('8','14','200');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('8','15','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('8','16','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('8','17','50');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('8','18','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('9','1','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('9','2','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('9','3','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('9','4','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('9','5','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('9','6','200');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('9','7','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('9','8','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('9','9','50');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('9','10','50');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('9','11','50');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('9','12','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('9','13','50');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('9','14','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('9','15','200');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('9','16','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('9','17','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('9','18','200');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('10','1','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('10','2','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('10','3','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('10','4','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('10','5','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('10','6','50');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('10','7','200');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('10','8','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('10','9','200');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('10','10','50');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('10','11','50');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('10','12','200');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('10','13','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('10','14','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('10','15','200');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('10','16','50');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('10','17','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('10','18','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('11','1','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('11','2','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('11','3','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('11','4','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('11','5','200');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('11','6','200');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('11','7','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('11','8','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('11','9','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('11','10','200');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('11','11','50');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('11','12','50');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('11','13','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('11','14','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('11','15','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('11','16','50');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('11','17','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('11','18','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('12','1','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('12','2','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('12','3','50');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('12','4','50');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('12','5','200');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('12','6','200');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('12','7','50');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('12','8','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('12','9','50');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('12','10','50');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('12','11','200');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('12','12','50');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('12','13','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('12','14','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('12','15','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('12','16','50');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('12','17','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('12','18','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('13','1','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('13','2','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('13','3','200');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('13','4','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('13','5','0');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('13','6','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('13','7','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('13','8','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('13','9','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('13','10','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('13','11','200');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('13','12','50');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('13','13','50');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('13','14','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('13','15','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('13','16','50');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('13','17','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('13','18','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('14','1','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('14','2','200');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('14','3','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('14','4','200');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('14','5','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('14','6','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('14','7','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('14','8','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('14','9','50');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('14','10','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('14','11','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('14','12','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('14','13','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('14','14','50');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('14','15','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('14','16','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('14','17','0');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('14','18','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('15','1','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('15','2','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('15','3','200');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('15','4','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('15','5','200');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('15','6','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('15','7','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('15','8','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('15','9','50');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('15','10','50');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('15','11','50');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('15','12','200');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('15','13','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('15','14','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('15','15','50');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('15','16','200');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('15','17','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('15','18','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('16','1','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('16','2','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('16','3','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('16','4','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('16','5','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('16','6','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('16','7','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('16','8','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('16','9','50');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('16','10','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('16','11','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('16','12','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('16','13','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('16','14','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('16','15','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('16','16','200');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('16','17','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('16','18','0');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('17','1','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('17','2','50');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('17','3','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('17','4','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('17','5','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('17','6','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('17','7','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('17','8','200');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('17','9','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('17','10','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('17','11','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('17','12','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('17','13','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('17','14','200');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('17','15','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('17','16','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('17','17','50');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('17','18','50');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('18','1','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('18','2','200');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('18','3','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('18','4','50');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('18','5','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('18','6','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('18','7','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('18','8','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('18','9','50');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('18','10','50');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('18','11','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('18','12','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('18','13','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('18','14','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('18','15','100');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('18','16','200');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('18','17','200');
INSERT INTO type_effectiveness (offense_type_id,defense_type_id,damage_modifier) VALUES ('18','18','100');

-- status_effects
-- regions
INSERT INTO regions (id,name) VALUES ('1','kanto');
INSERT INTO regions (id,name) VALUES ('2','johto');
INSERT INTO regions (id,name) VALUES ('3','hoenn');
INSERT INTO regions (id,name) VALUES ('4','sinnoh');
INSERT INTO regions (id,name) VALUES ('5','unova');
INSERT INTO regions (id,name) VALUES ('6','kalos');
INSERT INTO regions (id,name) VALUES ('7','alola');
INSERT INTO regions (id,name) VALUES ('8','galar');

-- generations (regions)
INSERT INTO generations (id,region_id,name) VALUES ('1','1','generation-i');
INSERT INTO generations (id,region_id,name) VALUES ('2','2','generation-ii');
INSERT INTO generations (id,region_id,name) VALUES ('3','3','generation-iii');
INSERT INTO generations (id,region_id,name) VALUES ('4','4','generation-iv');
INSERT INTO generations (id,region_id,name) VALUES ('5','5','generation-v');
INSERT INTO generations (id,region_id,name) VALUES ('6','6','generation-vi');
INSERT INTO generations (id,region_id,name) VALUES ('7','7','generation-vii');
INSERT INTO generations (id,region_id,name) VALUES ('8','8','generation-viii');

-- locations (region)
-- items (generation only)
-- natures
-- languages

--HAS DEPENDANCIES
-- card_metadata
-- trainer_cards
-- energy_cards
-- energy_card_contents
-- pkmn_cards
-- retreat_cost
-- pkmn_card_evolutions
-- card_attacks
-- card_attack_costs
-- pokemon
-- go_stats
-- pokemon_evolution_condition
-- pokemon_abilities
-- pokemon_moves
-- pokemon_egg_groups
-- move_effects
-- type_immunity
-- games
-- starters
-- trainers
-- catch_locations
-- game_pokemon
-- trainer_teams
-- berry_locations
-- berry_effects
-- game_locations
-- game_items
-- language_translations
-- move_translations
-- type_translations
-- ability_translations
-- generation_translations
-- region_translations
-- game_translations
-- item_translations
-- nature_translations
-- location_translations
-- POKEMON
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('1','bulbasaur','1','69','7','64','1','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('2','ivysaur','2','130','10','142','2','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('3','venusaur','3','1000','20','263','3','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('4','charmander','4','85','6','62','5','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('5','charmeleon','5','190','11','142','6','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('6','charizard','6','905','17','267','7','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('7','squirtle','7','90','5','63','10','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('8','wartortle','8','225','10','142','11','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('9','blastoise','9','855','16','265','12','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10','caterpie','10','29','3','39','14','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('11','metapod','11','99','7','72','15','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('12','butterfree','12','320','11','198','16','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('13','weedle','13','32','3','39','17','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('14','kakuna','14','100','6','72','18','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('15','beedrill','15','295','10','178','19','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('16','pidgey','16','18','3','50','21','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('17','pidgeotto','17','300','11','122','22','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('18','pidgeot','18','395','15','216','23','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('19','rattata','19','35','3','51','25','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('20','raticate','20','185','7','145','27','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('21','spearow','21','20','3','52','30','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('22','fearow','22','380','12','155','31','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('23','ekans','23','69','20','58','32','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('24','arbok','24','650','35','157','33','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('25','pikachu','25','60','4','112','35','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('26','raichu','26','300','8','243','51','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('27','sandshrew','27','120','6','60','53','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('28','sandslash','28','295','10','158','55','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('29','nidoran-f','29','70','4','55','57','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('30','nidorina','30','200','8','128','58','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('31','nidoqueen','31','600','13','253','59','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('32','nidoran-m','32','90','5','55','60','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('33','nidorino','33','195','9','128','61','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('34','nidoking','34','620','14','253','62','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('35','clefairy','35','75','6','113','64','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('36','clefable','36','400','13','242','65','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('37','vulpix','37','99','6','60','66','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('38','ninetales','38','199','11','177','68','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('39','jigglypuff','39','55','5','95','71','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('40','wigglytuff','40','120','10','218','72','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('41','zubat','41','75','8','49','73','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('42','golbat','42','550','16','159','74','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('43','oddish','43','54','5','64','76','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('44','gloom','44','86','8','138','77','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('45','vileplume','45','186','12','245','78','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('46','paras','46','54','3','57','80','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('47','parasect','47','295','10','142','81','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('48','venonat','48','300','10','61','82','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('49','venomoth','49','125','15','158','83','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('50','diglett','50','8','2','53','84','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('51','dugtrio','51','333','7','149','86','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('52','meowth','52','42','4','58','88','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('53','persian','53','320','10','154','91','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('54','psyduck','54','196','8','64','93','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('55','golduck','55','766','17','175','94','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('56','mankey','56','280','5','61','95','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('57','primeape','57','320','10','159','96','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('58','growlithe','58','190','7','70','97','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('59','arcanine','59','1550','19','194','98','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('60','poliwag','60','124','6','60','99','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('61','poliwhirl','61','200','10','135','100','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('62','poliwrath','62','540','13','255','101','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('63','abra','63','195','9','62','103','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('64','kadabra','64','565','13','140','104','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('65','alakazam','65','480','15','250','105','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('66','machop','66','195','8','61','107','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('67','machoke','67','705','15','142','108','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('68','machamp','68','1300','16','253','109','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('69','bellsprout','69','40','7','60','110','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('70','weepinbell','70','64','10','137','111','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('71','victreebel','71','155','17','221','112','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('72','tentacool','72','455','9','67','113','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('73','tentacruel','73','550','16','180','114','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('74','geodude','74','200','4','60','115','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('75','graveler','75','1050','10','137','117','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('76','golem','76','3000','14','223','119','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('77','ponyta','77','300','10','82','121','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('78','rapidash','78','950','17','175','123','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('79','slowpoke','79','360','12','63','125','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('80','slowbro','80','785','16','172','127','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('81','magnemite','81','60','3','65','132','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('82','magneton','82','600','10','163','133','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('83','farfetchd','83','150','8','132','135','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('84','doduo','84','392','14','62','137','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('85','dodrio','85','852','18','165','138','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('86','seel','86','900','11','65','139','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('87','dewgong','87','1200','17','166','140','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('88','grimer','88','300','9','65','141','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('89','muk','89','300','12','175','143','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('90','shellder','90','40','3','61','145','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('91','cloyster','91','1325','15','184','146','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('92','gastly','92','1','13','62','147','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('93','haunter','93','1','16','142','148','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('94','gengar','94','405','15','250','149','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('95','onix','95','2100','88','77','151','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('96','drowzee','96','324','10','66','154','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('97','hypno','97','756','16','169','155','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('98','krabby','98','65','4','65','156','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('99','kingler','99','600','13','166','157','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('100','voltorb','100','104','5','66','158','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('101','electrode','101','666','12','172','159','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('102','exeggcute','102','25','4','65','160','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('103','exeggutor','103','1200','20','186','161','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('104','cubone','104','65','4','64','163','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('105','marowak','105','450','10','149','164','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('106','hitmonlee','106','498','15','159','168','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('107','hitmonchan','107','502','14','159','169','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('108','lickitung','108','655','12','77','171','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('109','koffing','109','10','6','68','173','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('110','weezing','110','95','12','172','174','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('111','rhyhorn','111','1150','10','69','176','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('112','rhydon','112','1200','19','170','177','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('113','chansey','113','346','11','395','180','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('114','tangela','114','350','10','87','182','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('115','kangaskhan','115','800','22','172','184','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('116','horsea','116','80','4','59','186','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('117','seadra','117','250','12','154','187','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('118','goldeen','118','150','6','64','189','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('119','seaking','119','390','13','158','190','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('120','staryu','120','345','8','68','191','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('121','starmie','121','800','11','182','192','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('122','mr-mime','122','545','13','161','194','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('123','scyther','123','560','15','100','196','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('124','jynx','124','406','14','159','200','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('125','electabuzz','125','300','11','172','202','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('126','magmar','126','445','13','173','205','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('127','pinsir','127','550','15','175','207','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('128','tauros','128','884','14','172','209','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('129','magikarp','129','100','9','40','210','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('130','gyarados','130','2350','65','189','211','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('131','lapras','131','2200','25','187','213','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('132','ditto','132','40','3','101','214','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('133','eevee','133','65','3','65','215','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('134','vaporeon','134','290','10','184','217','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('135','jolteon','135','245','8','184','218','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('136','flareon','136','250','9','184','219','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('137','porygon','137','365','8','79','225','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('138','omanyte','138','75','4','71','228','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('139','omastar','139','350','10','173','229','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('140','kabuto','140','115','5','71','230','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('141','kabutops','141','405','13','173','231','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('142','aerodactyl','142','590','18','180','232','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('143','snorlax','143','4600','21','189','235','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('144','articuno','144','554','17','290','236','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('145','zapdos','145','526','16','290','238','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('146','moltres','146','600','20','290','240','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('147','dratini','147','33','18','60','242','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('148','dragonair','148','165','40','147','243','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('149','dragonite','149','2100','22','300','244','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('150','mewtwo','150','1220','20','340','245','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('151','mew','151','40','4','300','248','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('152','chikorita','152','64','9','64','249','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('153','bayleef','153','158','12','142','250','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('154','meganium','154','1005','18','236','251','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('155','cyndaquil','155','79','5','62','252','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('156','quilava','156','190','9','142','253','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('157','typhlosion','157','795','17','240','254','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('158','totodile','158','95','6','63','255','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('159','croconaw','159','250','11','142','256','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('160','feraligatr','160','888','23','239','257','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('161','sentret','161','60','8','43','258','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('162','furret','162','325','18','145','259','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('163','hoothoot','163','212','7','52','260','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('164','noctowl','164','408','16','158','261','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('165','ledyba','165','108','10','53','262','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('166','ledian','166','356','14','137','263','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('167','spinarak','167','85','5','50','264','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('168','ariados','168','335','11','140','265','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('169','crobat','169','750','18','268','75','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('170','chinchou','170','120','5','66','266','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('171','lanturn','171','225','12','161','267','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('172','pichu','172','20','3','41','34','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('173','cleffa','173','30','3','44','63','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('174','igglybuff','174','10','3','42','70','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('175','togepi','175','15','3','49','268','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('176','togetic','176','32','6','142','269','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('177','natu','177','20','2','64','271','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('178','xatu','178','150','15','165','272','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('179','mareep','179','78','6','56','273','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('180','flaaffy','180','133','8','128','274','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('181','ampharos','181','615','14','230','275','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('182','bellossom','182','58','4','245','79','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('183','marill','183','85','4','88','278','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('184','azumarill','184','285','8','210','279','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('185','sudowoodo','185','380','12','144','281','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('186','politoed','186','339','11','250','102','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('187','hoppip','187','5','4','50','282','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('188','skiploom','188','10','6','119','283','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('189','jumpluff','189','30','8','207','284','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('190','aipom','190','115','8','72','285','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('191','sunkern','191','18','3','36','287','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('192','sunflora','192','85','8','149','288','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('193','yanma','193','380','12','78','289','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('194','wooper','194','85','4','42','291','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('195','quagsire','195','750','14','151','292','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('196','espeon','196','265','9','184','220','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('197','umbreon','197','270','10','184','221','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('198','murkrow','198','21','5','81','293','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('199','slowking','199','795','20','172','130','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('200','misdreavus','200','10','7','87','295','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('201','unown','201','50','5','118','297','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('202','wobbuffet','202','285','13','142','299','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('203','girafarig','203','415','15','159','300','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('204','pineco','204','72','6','58','301','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('205','forretress','205','1258','12','163','302','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('206','dunsparce','206','140','15','145','303','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('207','gligar','207','648','11','86','304','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('208','steelix','208','4000','92','179','152','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('209','snubbull','209','78','6','60','306','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('210','granbull','210','487','14','158','307','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('211','qwilfish','211','39','5','88','308','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('212','scizor','212','1180','18','175','197','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('213','shuckle','213','205','6','177','309','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('214','heracross','214','540','15','175','310','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('215','sneasel','215','280','9','86','312','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('216','teddiursa','216','88','6','66','314','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('217','ursaring','217','1258','18','175','315','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('218','slugma','218','350','7','50','316','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('219','magcargo','219','550','8','151','317','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('220','swinub','220','65','4','50','318','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('221','piloswine','221','558','11','158','319','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('222','corsola','222','50','6','144','321','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('223','remoraid','223','120','6','60','323','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('224','octillery','224','285','9','168','324','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('225','delibird','225','160','9','116','325','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('226','mantine','226','2200','21','170','327','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('227','skarmory','227','505','17','163','328','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('228','houndour','228','108','6','66','329','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('229','houndoom','229','350','14','175','330','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('230','kingdra','230','1520','18','270','188','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('231','phanpy','231','335','5','66','332','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('232','donphan','232','1200','11','175','333','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('233','porygon2','233','325','6','180','226','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('234','stantler','234','712','14','163','334','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('235','smeargle','235','580','12','88','335','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('236','tyrogue','236','210','7','42','167','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('237','hitmontop','237','480','14','159','170','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('238','smoochum','238','60','4','61','199','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('239','elekid','239','235','6','72','201','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('240','magby','240','214','7','73','204','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('241','miltank','241','755','12','172','336','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('242','blissey','242','468','15','635','181','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('243','raikou','243','1780','19','290','337','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('244','entei','244','1980','21','290','338','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('245','suicune','245','1870','20','290','339','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('246','larvitar','246','720','6','60','340','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('247','pupitar','247','1520','12','144','341','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('248','tyranitar','248','2020','20','300','342','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('249','lugia','249','2160','52','340','344','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('250','ho-oh','250','1990','38','340','345','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('251','celebi','251','50','6','300','346','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('252','treecko','252','50','5','62','347','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('253','grovyle','253','216','9','142','348','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('254','sceptile','254','522','17','265','349','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('255','torchic','255','25','4','62','351','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('256','combusken','256','195','9','142','352','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('257','blaziken','257','520','19','265','353','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('258','mudkip','258','76','4','62','355','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('259','marshtomp','259','280','7','142','356','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('260','swampert','260','819','15','268','357','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('261','poochyena','261','136','5','56','359','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('262','mightyena','262','370','10','147','360','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('263','zigzagoon','263','175','4','56','361','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('264','linoone','264','325','5','147','363','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('265','wurmple','265','36','3','56','365','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('266','silcoon','266','100','6','72','366','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('267','beautifly','267','284','10','178','367','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('268','cascoon','268','115','7','72','368','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('269','dustox','269','316','12','173','369','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('270','lotad','270','26','5','44','370','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('271','lombre','271','325','12','119','371','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('272','ludicolo','272','550','15','240','372','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('273','seedot','273','40','5','44','373','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('274','nuzleaf','274','280','10','119','374','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('275','shiftry','275','596','13','240','375','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('276','taillow','276','23','3','54','376','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('277','swellow','277','198','7','159','377','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('278','wingull','278','95','6','54','378','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('279','pelipper','279','280','12','154','379','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('280','ralts','280','66','4','40','380','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('281','kirlia','281','202','8','97','381','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('282','gardevoir','282','484','16','259','382','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('283','surskit','283','17','5','54','386','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('284','masquerain','284','36','8','159','387','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('285','shroomish','285','45','4','59','388','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('286','breloom','286','392','12','161','389','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('287','slakoth','287','240','8','56','390','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('288','vigoroth','288','465','14','154','391','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('289','slaking','289','1305','20','252','392','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('290','nincada','290','55','5','53','393','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('291','ninjask','291','120','8','160','394','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('292','shedinja','292','12','8','83','395','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('293','whismur','293','163','6','48','396','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('294','loudred','294','405','10','126','397','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('295','exploud','295','840','15','245','398','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('296','makuhita','296','864','10','47','399','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('297','hariyama','297','2538','23','166','400','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('298','azurill','298','20','2','38','277','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('299','nosepass','299','970','10','75','401','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('300','skitty','300','110','6','52','403','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('301','delcatty','301','326','11','140','404','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('302','sableye','302','110','5','133','405','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('303','mawile','303','115','6','133','407','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('304','aron','304','600','4','66','409','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('305','lairon','305','1200','9','151','410','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('306','aggron','306','3600','21','265','411','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('307','meditite','307','112','6','56','413','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('308','medicham','308','315','13','144','414','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('309','electrike','309','152','6','59','416','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('310','manectric','310','402','15','166','417','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('311','plusle','311','42','4','142','419','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('312','minun','312','42','4','142','420','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('313','volbeat','313','177','7','151','421','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('314','illumise','314','177','6','151','422','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('315','roselia','315','20','3','140','424','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('316','gulpin','316','103','4','60','426','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('317','swalot','317','800','17','163','427','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('318','carvanha','318','208','8','61','428','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('319','sharpedo','319','888','18','161','429','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('320','wailmer','320','1300','20','80','431','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('321','wailord','321','3980','145','175','432','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('322','numel','322','240','7','61','433','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('323','camerupt','323','2200','19','161','434','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('324','torkoal','324','804','5','165','436','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('325','spoink','325','306','7','66','437','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('326','grumpig','326','715','9','165','438','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('327','spinda','327','50','11','126','439','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('328','trapinch','328','150','7','58','440','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('329','vibrava','329','153','11','119','441','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('330','flygon','330','820','20','260','442','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('331','cacnea','331','513','4','67','443','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('332','cacturne','332','774','13','166','444','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('333','swablu','333','12','4','62','445','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('334','altaria','334','206','11','172','446','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('335','zangoose','335','403','13','160','448','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('336','seviper','336','525','27','160','449','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('337','lunatone','337','1680','10','161','450','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('338','solrock','338','1540','12','161','451','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('339','barboach','339','19','4','58','452','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('340','whiscash','340','236','9','164','453','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('341','corphish','341','115','6','62','454','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('342','crawdaunt','342','328','11','164','455','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('343','baltoy','343','215','5','60','456','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('344','claydol','344','1080','15','175','457','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('345','lileep','345','238','10','71','458','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('346','cradily','346','604','15','173','459','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('347','anorith','347','125','7','71','460','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('348','armaldo','348','682','15','173','461','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('349','feebas','349','74','6','40','462','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('350','milotic','350','1620','62','189','463','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('351','castform','351','8','3','147','464','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('352','kecleon','352','220','10','154','468','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('353','shuppet','353','23','6','59','469','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('354','banette','354','125','11','159','470','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('355','duskull','355','150','8','59','472','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('356','dusclops','356','306','16','159','473','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('357','tropius','357','1000','20','161','475','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('358','chimecho','358','10','6','159','477','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('359','absol','359','470','12','163','478','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('360','wynaut','360','140','6','52','298','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('361','snorunt','361','168','7','60','480','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('362','glalie','362','2565','15','168','481','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('363','spheal','363','395','8','58','484','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('364','sealeo','364','876','11','144','485','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('365','walrein','365','1506','14','265','486','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('366','clamperl','366','525','4','69','487','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('367','huntail','367','270','17','170','488','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('368','gorebyss','368','226','18','170','489','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('369','relicanth','369','234','10','170','490','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('370','luvdisc','370','87','6','116','491','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('371','bagon','371','421','6','60','492','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('372','shelgon','372','1105','11','147','493','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('373','salamence','373','1026','15','300','494','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('374','beldum','374','952','6','60','496','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('375','metang','375','2025','12','147','497','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('376','metagross','376','5500','16','300','498','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('377','regirock','377','2300','17','290','500','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('378','regice','378','1750','18','290','501','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('379','registeel','379','2050','19','290','502','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('380','latias','380','400','14','300','503','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('381','latios','381','600','20','300','505','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('382','kyogre','382','3520','45','335','507','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('383','groudon','383','9500','35','335','509','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('384','rayquaza','384','2065','70','340','511','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('385','jirachi','385','11','3','300','513','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('386','deoxys-normal','386','608','17','270','514','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('387','turtwig','387','102','4','64','518','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('388','grotle','388','970','11','142','519','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('389','torterra','389','3100','22','236','520','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('390','chimchar','390','62','5','62','521','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('391','monferno','391','220','9','142','522','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('392','infernape','392','550','12','240','523','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('393','piplup','393','52','4','63','524','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('394','prinplup','394','230','8','142','525','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('395','empoleon','395','845','17','239','526','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('396','starly','396','20','3','49','527','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('397','staravia','397','155','6','119','528','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('398','staraptor','398','249','12','218','529','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('399','bidoof','399','200','5','50','530','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('400','bibarel','400','315','10','144','531','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('401','kricketot','401','22','3','39','532','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('402','kricketune','402','255','10','134','533','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('403','shinx','403','95','5','53','534','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('404','luxio','404','305','9','127','535','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('405','luxray','405','420','14','262','536','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('406','budew','406','12','2','56','423','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('407','roserade','407','145','9','258','425','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('408','cranidos','408','315','9','70','537','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('409','rampardos','409','1025','16','173','538','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('410','shieldon','410','570','5','70','539','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('411','bastiodon','411','1495','13','173','540','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('412','burmy','412','34','2','45','541','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('413','wormadam-plant','413','65','5','148','542','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('414','mothim','414','233','9','148','545','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('415','combee','415','55','3','49','546','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('416','vespiquen','416','385','12','166','547','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('417','pachirisu','417','39','4','142','548','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('418','buizel','418','295','7','66','549','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('419','floatzel','419','335','11','173','550','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('420','cherubi','420','33','4','55','551','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('421','cherrim','421','93','5','158','552','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('422','shellos','422','63','3','65','553','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('423','gastrodon','423','299','9','166','554','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('424','ambipom','424','203','12','169','286','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('425','drifloon','425','12','4','70','555','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('426','drifblim','426','150','12','174','556','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('427','buneary','427','55','4','70','557','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('428','lopunny','428','333','12','168','558','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('429','mismagius','429','44','9','173','296','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('430','honchkrow','430','273','9','177','294','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('431','glameow','431','39','5','62','560','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('432','purugly','432','438','10','158','561','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('433','chingling','433','6','2','57','476','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('434','stunky','434','192','4','66','562','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('435','skuntank','435','380','10','168','563','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('436','bronzor','436','605','5','60','564','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('437','bronzong','437','1870','13','175','565','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('438','bonsly','438','150','5','58','280','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('439','mime-jr','439','130','6','62','193','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('440','happiny','440','244','6','110','179','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('441','chatot','441','19','5','144','566','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('442','spiritomb','442','1080','10','170','567','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('443','gible','443','205','7','60','568','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('444','gabite','444','560','14','144','569','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('445','garchomp','445','950','19','300','570','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('446','munchlax','446','1050','6','78','234','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('447','riolu','447','202','7','57','572','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('448','lucario','448','540','12','184','573','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('449','hippopotas','449','495','8','66','575','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('450','hippowdon','450','3000','20','184','576','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('451','skorupi','451','120','8','66','577','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('452','drapion','452','615','13','175','578','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('453','croagunk','453','230','7','60','579','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('454','toxicroak','454','444','13','172','580','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('455','carnivine','455','270','14','159','581','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('456','finneon','456','70','4','66','582','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('457','lumineon','457','240','12','161','583','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('458','mantyke','458','650','10','69','326','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('459','snover','459','505','10','67','584','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('460','abomasnow','460','1355','22','173','585','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('461','weavile','461','340','11','179','313','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('462','magnezone','462','1800','12','268','134','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('463','lickilicky','463','1400','17','180','172','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('464','rhyperior','464','2828','24','268','178','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('465','tangrowth','465','1286','20','187','183','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('466','electivire','466','1386','18','270','203','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('467','magmortar','467','680','16','270','206','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('468','togekiss','468','380','15','273','270','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('469','yanmega','469','515','19','180','290','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('470','leafeon','470','255','10','184','222','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('471','glaceon','471','259','8','184','223','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('472','gliscor','472','425','20','179','305','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('473','mamoswine','473','2910','25','265','320','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('474','porygon-z','474','340','9','268','227','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('475','gallade','475','520','16','259','384','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('476','probopass','476','3400','14','184','402','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('477','dusknoir','477','1066','22','263','474','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('478','froslass','478','266','13','168','483','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('479','rotom','479','3','3','154','587','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('480','uxie','480','3','3','290','593','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('481','mesprit','481','3','3','290','594','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('482','azelf','482','3','3','290','595','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('483','dialga','483','6830','54','340','596','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('484','palkia','484','3360','42','340','597','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('485','heatran','485','4300','17','300','598','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('486','regigigas','486','4200','37','335','599','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('487','giratina-altered','487','7500','45','340','600','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('488','cresselia','488','856','15','300','602','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('489','phione','489','31','4','216','603','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('490','manaphy','490','14','3','270','604','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('491','darkrai','491','505','15','270','605','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('492','shaymin-land','492','21','2','270','606','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('493','arceus','493','3200','32','324','608','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('494','victini','494','40','4','300','609','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('495','snivy','495','81','6','62','610','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('496','servine','496','160','8','145','611','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('497','serperior','497','630','33','238','612','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('498','tepig','498','99','5','62','613','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('499','pignite','499','555','10','146','614','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('500','emboar','500','1500','16','238','615','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('501','oshawott','501','59','5','62','616','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('502','dewott','502','245','8','145','617','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('503','samurott','503','946','15','238','618','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('504','patrat','504','116','5','51','619','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('505','watchog','505','270','11','147','620','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('506','lillipup','506','41','4','55','621','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('507','herdier','507','147','9','130','622','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('508','stoutland','508','610','12','250','623','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('509','purrloin','509','101','4','56','624','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('510','liepard','510','375','11','156','625','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('511','pansage','511','105','6','63','626','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('512','simisage','512','305','11','174','627','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('513','pansear','513','110','6','63','628','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('514','simisear','514','280','10','174','629','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('515','panpour','515','135','6','63','630','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('516','simipour','516','290','10','174','631','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('517','munna','517','233','6','58','632','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('518','musharna','518','605','11','170','633','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('519','pidove','519','21','3','53','634','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('520','tranquill','520','150','6','125','635','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('521','unfezant','521','290','12','244','636','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('522','blitzle','522','298','8','59','637','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('523','zebstrika','523','795','16','174','638','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('524','roggenrola','524','180','4','56','639','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('525','boldore','525','1020','9','137','640','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('526','gigalith','526','2600','17','258','641','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('527','woobat','527','21','4','65','642','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('528','swoobat','528','105','9','149','643','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('529','drilbur','529','85','3','66','644','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('530','excadrill','530','404','7','178','645','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('531','audino','531','310','11','390','646','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('532','timburr','532','125','6','61','648','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('533','gurdurr','533','400','12','142','649','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('534','conkeldurr','534','870','14','253','650','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('535','tympole','535','45','5','59','651','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('536','palpitoad','536','170','8','134','652','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('537','seismitoad','537','620','15','255','653','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('538','throh','538','555','13','163','654','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('539','sawk','539','510','14','163','655','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('540','sewaddle','540','25','3','62','656','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('541','swadloon','541','73','5','133','657','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('542','leavanny','542','205','12','225','658','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('543','venipede','543','53','4','52','659','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('544','whirlipede','544','585','12','126','660','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('545','scolipede','545','2005','25','243','661','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('546','cottonee','546','6','3','56','662','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('547','whimsicott','547','66','7','168','663','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('548','petilil','548','66','5','56','664','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('549','lilligant','549','163','11','168','665','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('550','basculin-red-striped','550','180','10','161','666','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('551','sandile','551','152','7','58','668','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('552','krokorok','552','334','10','123','669','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('553','krookodile','553','963','15','260','670','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('554','darumaka','554','375','6','63','671','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('555','darmanitan-standard','555','929','13','168','673','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('556','maractus','556','280','10','161','677','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('557','dwebble','557','145','3','65','678','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('558','crustle','558','2000','14','170','679','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('559','scraggy','559','118','6','70','680','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('560','scrafty','560','300','11','171','681','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('561','sigilyph','561','140','14','172','682','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('562','yamask','562','15','5','61','683','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('563','cofagrigus','563','765','17','169','685','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('564','tirtouga','564','165','7','71','686','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('565','carracosta','565','810','12','173','687','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('566','archen','566','95','5','71','688','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('567','archeops','567','320','14','177','689','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('568','trubbish','568','310','6','66','690','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('569','garbodor','569','1073','19','166','691','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('570','zorua','570','125','7','66','692','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('571','zoroark','571','811','16','179','693','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('572','minccino','572','58','4','60','694','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('573','cinccino','573','75','5','165','695','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('574','gothita','574','58','4','58','696','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('575','gothorita','575','180','7','137','697','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('576','gothitelle','576','440','15','245','698','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('577','solosis','577','10','3','58','699','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('578','duosion','578','80','6','130','700','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('579','reuniclus','579','201','10','245','701','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('580','ducklett','580','55','5','61','702','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('581','swanna','581','242','13','166','703','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('582','vanillite','582','57','4','61','704','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('583','vanillish','583','410','11','138','705','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('584','vanilluxe','584','575','13','268','706','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('585','deerling','585','195','6','67','707','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('586','sawsbuck','586','925','19','166','708','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('587','emolga','587','50','4','150','709','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('588','karrablast','588','59','5','63','710','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('589','escavalier','589','330','10','173','711','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('590','foongus','590','10','2','59','712','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('591','amoonguss','591','105','6','162','713','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('592','frillish','592','330','12','67','714','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('593','jellicent','593','1350','22','168','715','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('594','alomomola','594','316','12','165','716','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('595','joltik','595','6','1','64','717','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('596','galvantula','596','143','8','165','718','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('597','ferroseed','597','188','6','61','719','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('598','ferrothorn','598','1100','10','171','720','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('599','klink','599','210','3','60','721','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('600','klang','600','510','6','154','722','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('601','klinklang','601','810','6','260','723','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('602','tynamo','602','3','2','55','724','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('603','eelektrik','603','220','12','142','725','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('604','eelektross','604','805','21','232','726','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('605','elgyem','605','90','5','67','727','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('606','beheeyem','606','345','10','170','728','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('607','litwick','607','31','3','55','729','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('608','lampent','608','130','6','130','730','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('609','chandelure','609','343','10','260','731','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('610','axew','610','180','6','64','732','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('611','fraxure','611','360','10','144','733','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('612','haxorus','612','1055','18','270','734','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('613','cubchoo','613','85','5','61','735','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('614','beartic','614','2600','26','177','736','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('615','cryogonal','615','1480','11','180','737','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('616','shelmet','616','77','4','61','738','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('617','accelgor','617','253','8','173','739','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('618','stunfisk','618','110','7','165','740','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('619','mienfoo','619','200','9','70','742','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('620','mienshao','620','355','14','179','743','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('621','druddigon','621','1390','16','170','744','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('622','golett','622','920','10','61','745','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('623','golurk','623','3300','28','169','746','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('624','pawniard','624','102','5','68','747','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('625','bisharp','625','700','16','172','748','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('626','bouffalant','626','946','16','172','749','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('627','rufflet','627','105','5','70','750','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('628','braviary','628','410','15','179','751','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('629','vullaby','629','90','5','74','752','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('630','mandibuzz','630','395','12','179','753','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('631','heatmor','631','580','14','169','754','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('632','durant','632','330','3','169','755','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('633','deino','633','173','8','60','756','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('634','zweilous','634','500','14','147','757','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('635','hydreigon','635','1600','18','300','758','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('636','larvesta','636','288','11','72','759','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('637','volcarona','637','460','16','275','760','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('638','cobalion','638','2500','21','290','761','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('639','terrakion','639','2600','19','290','762','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('640','virizion','640','2000','20','290','763','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('641','tornadus-incarnate','641','630','15','290','764','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('642','thundurus-incarnate','642','610','15','290','766','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('643','reshiram','643','3300','32','340','768','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('644','zekrom','644','3450','29','340','769','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('645','landorus-incarnate','645','680','15','300','770','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('646','kyurem','646','3250','30','330','772','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('647','keldeo-ordinary','647','485','14','290','775','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('648','meloetta-aria','648','65','6','270','777','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('649','genesect','649','825','15','300','779','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('650','chespin','650','90','4','63','780','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('651','quilladin','651','290','7','142','781','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('652','chesnaught','652','900','16','239','782','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('653','fennekin','653','94','4','61','783','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('654','braixen','654','145','10','143','784','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('655','delphox','655','390','15','240','785','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('656','froakie','656','70','3','63','786','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('657','frogadier','657','109','6','142','787','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('658','greninja','658','400','15','239','788','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('659','bunnelby','659','50','4','47','791','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('660','diggersby','660','424','10','148','792','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('661','fletchling','661','17','3','56','793','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('662','fletchinder','662','160','7','134','794','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('663','talonflame','663','245','12','175','795','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('664','scatterbug','664','25','3','40','796','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('665','spewpa','665','84','3','75','797','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('666','vivillon','666','170','12','185','798','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('667','litleo','667','135','6','74','799','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('668','pyroar','668','815','15','177','800','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('669','flabebe','669','1','1','61','801','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('670','floette','670','9','2','130','802','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('671','florges','671','100','11','248','804','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('672','skiddo','672','310','9','70','805','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('673','gogoat','673','910','17','186','806','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('674','pancham','674','80','6','70','807','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('675','pangoro','675','1360','21','173','808','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('676','furfrou','676','280','12','165','809','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('677','espurr','677','35','3','71','810','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('678','meowstic-male','678','85','6','163','811','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('679','honedge','679','20','8','65','813','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('680','doublade','680','45','8','157','814','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('681','aegislash-shield','681','530','17','250','815','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('682','spritzee','682','5','2','68','817','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('683','aromatisse','683','155','8','162','818','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('684','swirlix','684','35','4','68','819','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('685','slurpuff','685','50','8','168','820','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('686','inkay','686','35','4','58','821','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('687','malamar','687','470','15','169','822','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('688','binacle','688','310','5','61','823','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('689','barbaracle','689','960','13','175','824','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('690','skrelp','690','73','5','64','825','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('691','dragalge','691','815','18','173','826','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('692','clauncher','692','83','5','66','827','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('693','clawitzer','693','353','13','100','828','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('694','helioptile','694','60','5','58','829','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('695','heliolisk','695','210','10','168','830','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('696','tyrunt','696','260','8','72','831','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('697','tyrantrum','697','2700','25','182','832','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('698','amaura','698','252','13','72','833','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('699','aurorus','699','2250','27','104','834','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('700','sylveon','700','235','10','184','224','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('701','hawlucha','701','215','8','175','835','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('702','dedenne','702','22','2','151','836','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('703','carbink','703','57','3','100','837','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('704','goomy','704','28','3','60','838','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('705','sliggoo','705','175','8','158','839','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('706','goodra','706','1505','20','300','840','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('707','klefki','707','30','2','165','841','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('708','phantump','708','70','4','62','842','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('709','trevenant','709','710','15','166','843','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('710','pumpkaboo-average','710','50','4','67','844','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('711','gourgeist-average','711','125','9','173','848','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('712','bergmite','712','995','10','61','852','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('713','avalugg','713','5050','20','180','853','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('714','noibat','714','80','5','49','854','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('715','noivern','715','850','15','187','855','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('716','xerneas','716','2150','30','340','856','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('717','yveltal','717','2030','58','340','857','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('718','zygarde-50','718','3050','50','300','858','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('719','diancie','719','88','7','300','863','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('720','hoopa','720','90','5','270','865','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('721','volcanion','721','1950','17','300','867','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('722','rowlet','722','15','3','64','868','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('723','dartrix','723','160','7','147','869','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('724','decidueye','724','366','16','265','870','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('725','litten','725','43','4','64','871','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('726','torracat','726','250','7','147','872','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('727','incineroar','727','830','18','265','873','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('728','popplio','728','75','4','64','874','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('729','brionne','729','175','6','147','875','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('730','primarina','730','440','18','265','876','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('731','pikipek','731','12','3','53','877','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('732','trumbeak','732','148','6','124','878','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('733','toucannon','733','260','11','218','879','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('734','yungoos','734','60','4','51','880','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('735','gumshoos','735','142','7','146','881','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('736','grubbin','736','44','4','60','883','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('737','charjabug','737','105','5','140','884','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('738','vikavolt','738','450','15','250','885','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('739','crabrawler','739','70','6','68','887','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('740','crabominable','740','1800','17','167','888','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('741','oricorio-baile','741','34','6','167','889','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('742','cutiefly','742','2','1','61','893','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('743','ribombee','743','5','2','162','894','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('744','rockruff','744','92','5','56','896','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('745','lycanroc-midday','745','250','8','170','898','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('746','wishiwashi-solo','746','3','2','61','901','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('747','mareanie','747','80','4','61','903','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('748','toxapex','748','145','7','173','904','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('749','mudbray','749','1100','10','77','905','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('750','mudsdale','750','9200','25','175','906','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('751','dewpider','751','40','3','54','907','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('752','araquanid','752','820','18','159','908','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('753','fomantis','753','15','3','50','910','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('754','lurantis','754','185','9','168','911','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('755','morelull','755','15','2','57','913','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('756','shiinotic','756','115','10','142','914','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('757','salandit','757','48','6','64','915','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('758','salazzle','758','222','12','168','916','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('759','stufful','759','68','5','68','918','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('760','bewear','760','1350','21','175','919','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('761','bounsweet','761','32','3','42','920','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('762','steenee','762','82','7','102','921','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('763','tsareena','763','214','12','255','922','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('764','comfey','764','3','1','170','923','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('765','oranguru','765','760','15','172','924','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('766','passimian','766','828','20','172','925','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('767','wimpod','767','120','5','46','926','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('768','golisopod','768','1080','20','186','927','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('769','sandygast','769','700','5','64','928','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('770','palossand','770','2500','13','168','929','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('771','pyukumuku','771','12','3','144','930','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('772','type-null','772','1205','19','107','931','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('773','silvally','773','1005','23','285','932','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('774','minior-red-meteor','774','400','3','154','933','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('775','komala','775','199','4','168','947','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('776','turtonator','776','2120','20','170','948','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('777','togedemaru','777','33','3','152','949','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('778','mimikyu-disguised','778','7','2','167','951','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('779','bruxish','779','190','9','166','955','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('780','drampa','780','1850','30','170','956','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('781','dhelmise','781','2100','39','181','957','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('782','jangmo-o','782','297','6','60','958','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('783','hakamo-o','783','470','12','147','959','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('784','kommo-o','784','782','16','300','960','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('785','tapu-koko','785','205','18','285','962','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('786','tapu-lele','786','186','12','285','963','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('787','tapu-bulu','787','455','19','285','964','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('788','tapu-fini','788','212','13','285','965','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('789','cosmog','789','1','2','40','966','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('790','cosmoem','790','9999','1','140','967','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('791','solgaleo','791','2300','34','340','968','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('792','lunala','792','1200','40','340','969','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('793','nihilego','793','555','12','285','970','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('794','buzzwole','794','3336','24','285','971','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('795','pheromosa','795','250','18','285','972','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('796','xurkitree','796','1000','38','285','973','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('797','celesteela','797','9999','92','285','974','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('798','kartana','798','1','3','285','975','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('799','guzzlord','799','8880','55','285','976','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('800','necrozma','800','2300','24','300','977','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('801','magearna','801','805','10','300','981','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('802','marshadow','802','222','7','300','983','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('803','poipole','803','18','6','210','984','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('804','naganadel','804','1500','36','270','985','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('805','stakataka','805','8200','55','285','986','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('806','blacephalon','806','130','18','285','987','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('807','zeraora','807','445','15','300','988','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('808','meltan','808','80','2','150','989','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('809','melmetal','809','8000','25','300','990','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('810','grookey','810','50','3','62','991','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('811','thwackey','811','140','7','147','992','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('812','rillaboom','812','900','21','265','993','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('813','scorbunny','813','45','3','62','994','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('814','raboot','814','90','6','147','995','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('815','cinderace','815','330','14','265','996','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('816','sobble','816','40','3','62','997','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('817','drizzile','817','115','7','147','998','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('818','inteleon','818','452','19','265','999','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('819','skwovet','819','25','3','55','1000','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('820','greedent','820','60','6','161','1001','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('821','rookidee','821','18','2','49','1002','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('822','corvisquire','822','160','8','128','1003','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('823','corviknight','823','750','22','248','1004','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('824','blipbug','824','80','4','36','1005','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('825','dottler','825','195','4','117','1006','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('826','orbeetle','826','408','4','253','1007','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('827','nickit','827','89','6','49','1008','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('828','thievul','828','199','12','159','1009','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('829','gossifleur','829','22','4','50','1010','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('830','eldegoss','830','25','5','161','1011','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('831','wooloo','831','60','6','122','1012','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('832','dubwool','832','430','13','172','1013','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('833','chewtle','833','85','3','57','1014','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('834','drednaw','834','1155','10','170','1015','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('835','yamper','835','135','3','54','1016','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('836','boltund','836','340','10','172','1017','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('837','rolycoly','837','120','3','48','1018','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('838','carkol','838','780','11','144','1019','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('839','coalossal','839','3105','28','255','1020','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('840','applin','840','5','2','52','1021','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('841','flapple','841','10','3','170','1022','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('842','appletun','842','130','4','170','1023','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('843','silicobra','843','76','22','63','1024','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('844','sandaconda','844','655','38','179','1025','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('845','cramorant','845','180','8','166','1026','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('846','arrokuda','846','10','5','56','1029','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('847','barraskewda','847','300','13','172','1030','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('848','toxel','848','110','4','48','1031','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('849','toxtricity-amped','849','400','16','176','1032','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('850','sizzlipede','850','10','7','61','1034','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('851','centiskorch','851','1200','30','184','1035','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('852','clobbopus','852','40','6','62','1036','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('853','grapploct','853','390','16','168','1037','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('854','sinistea','854','2','1','62','1038','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('855','polteageist','855','4','2','178','1039','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('856','hatenna','856','34','4','53','1040','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('857','hattrem','857','48','6','130','1041','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('858','hatterene','858','51','21','255','1042','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('859','impidimp','859','55','4','53','1043','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('860','morgrem','860','125','8','130','1044','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('861','grimmsnarl','861','610','15','255','1045','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('862','obstagoon','862','460','16','260','1046','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('863','perrserker','863','280','8','154','1047','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('864','cursola','864','4','10','179','1048','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('865','sirfetchd','865','1170','8','177','1049','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('866','mr-rime','866','582','15','182','1050','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('867','runerigus','867','666','16','169','1051','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('868','milcery','868','3','2','54','1052','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('869','alcremie','869','5','3','173','1053','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('870','falinks','870','620','30','165','1054','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('871','pincurchin','871','10','3','152','1055','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('872','snom','872','38','3','37','1056','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('873','frosmoth','873','420','13','166','1057','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('874','stonjourner','874','5200','25','165','1058','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('875','eiscue-ice','875','890','14','165','1059','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('876','indeedee-male','876','280','9','166','1061','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('877','morpeko-full-belly','877','30','3','153','1063','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('878','cufant','878','1000','12','66','1065','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('879','copperajah','879','6500','30','175','1066','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('880','dracozolt','880','1900','18','177','1067','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('881','arctozolt','881','1500','23','177','1068','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('882','dracovish','882','2150','23','177','1069','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('883','arctovish','883','1750','20','177','1070','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('884','duraludon','884','400','18','187','1071','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('885','dreepy','885','20','5','54','1072','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('886','drakloak','886','110','14','144','1073','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('887','dragapult','887','500','30','300','1074','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('888','zacian','888','1100','28','335','1075','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('889','zamazenta','889','2100','29','335','1077','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('890','eternatus','890','9500','200','345','1079','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('891','kubfu','891','120','6','77','1081','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('892','urshifu-single-strike','892','1050','19','275','1082','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('893','zarude','893','700','18','300','1084','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('894','regieleki','894','1450','12','290','1086','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('895','regidrago','895','2000','21','290','1087','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('896','glastrier','896','8000','22','290','1088','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('897','spectrier','897','445','20','290','1089','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('898','calyrex','898','77','11','250','1090','1');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10001','deoxys-attack','386','608','17','270','515','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10002','deoxys-defense','386','608','17','270','516','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10003','deoxys-speed','386','608','17','270','517','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10004','wormadam-sandy','413','65','5','148','543','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10005','wormadam-trash','413','65','5','148','544','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10006','shaymin-sky','492','52','4','270','607','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10007','giratina-origin','487','6500','69','340','601','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10008','rotom-heat','479','3','3','182','588','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10009','rotom-wash','479','3','3','182','589','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10010','rotom-frost','479','3','3','182','590','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10011','rotom-fan','479','3','3','182','591','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10012','rotom-mow','479','3','3','182','592','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10013','castform-sunny','351','8','3','147','465','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10014','castform-rainy','351','8','3','147','466','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10015','castform-snowy','351','8','3','147','467','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10016','basculin-blue-striped','550','180','10','161','667','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10017','darmanitan-zen','555','929','13','189','674','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10018','meloetta-pirouette','648','65','6','270','778','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10019','tornadus-therian','641','630','14','290','765','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10020','thundurus-therian','642','610','30','290','767','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10021','landorus-therian','645','680','13','300','771','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10022','kyurem-black','646','3250','33','350','774','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10023','kyurem-white','646','3250','36','350','773','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10024','keldeo-resolute','647','485','14','290','776','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10025','meowstic-female','678','85','6','163','812','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10026','aegislash-blade','681','530','17','250','816','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10027','pumpkaboo-small','710','35','3','67','845','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10028','pumpkaboo-large','710','75','5','67','846','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10029','pumpkaboo-super','710','150','8','67','847','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10030','gourgeist-small','711','95','7','173','849','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10031','gourgeist-large','711','140','11','173','850','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10032','gourgeist-super','711','390','17','173','851','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10033','venusaur-mega','3','1555','24','281','4','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10034','charizard-mega-x','6','1105','17','285','8','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10035','charizard-mega-y','6','1005','17','285','9','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10036','blastoise-mega','9','1011','16','284','13','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10037','alakazam-mega','65','480','12','270','106','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10038','gengar-mega','94','405','14','270','150','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10039','kangaskhan-mega','115','1000','22','207','185','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10040','pinsir-mega','127','590','17','210','208','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10041','gyarados-mega','130','3050','65','224','212','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10042','aerodactyl-mega','142','790','21','215','233','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10043','mewtwo-mega-x','150','1270','23','351','246','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10044','mewtwo-mega-y','150','330','15','351','247','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10045','ampharos-mega','181','615','14','275','276','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10046','scizor-mega','212','1250','20','210','198','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10047','heracross-mega','214','625','17','210','311','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10048','houndoom-mega','229','495','19','210','331','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10049','tyranitar-mega','248','2550','25','315','343','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10050','blaziken-mega','257','520','19','284','354','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10051','gardevoir-mega','282','484','16','278','383','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10052','mawile-mega','303','235','10','168','408','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10053','aggron-mega','306','3950','22','284','412','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10054','medicham-mega','308','315','13','179','415','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10055','manectric-mega','310','440','18','201','418','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10056','banette-mega','354','130','12','194','471','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10057','absol-mega','359','490','12','198','479','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10058','garchomp-mega','445','950','19','315','571','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10059','lucario-mega','448','575','13','219','574','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10060','abomasnow-mega','460','1850','27','208','586','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10061','floette-eternal','670','9','2','243','803','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10062','latias-mega','380','520','18','315','504','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10063','latios-mega','381','700','23','315','506','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10064','swampert-mega','260','1020','19','286','358','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10065','sceptile-mega','254','552','19','284','350','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10066','sableye-mega','302','1610','5','168','406','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10067','altaria-mega','334','206','15','207','447','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10068','gallade-mega','475','564','16','278','385','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10069','audino-mega','531','320','15','425','647','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10070','sharpedo-mega','319','1303','25','196','430','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10071','slowbro-mega','80','1200','20','207','128','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10072','steelix-mega','208','7400','105','214','153','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10073','pidgeot-mega','18','505','22','261','24','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10074','glalie-mega','362','3502','21','203','482','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10075','diancie-mega','719','278','11','315','864','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10076','metagross-mega','376','9429','25','315','499','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10077','kyogre-primal','382','4300','98','347','508','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10078','groudon-primal','383','9997','50','347','510','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10079','rayquaza-mega','384','3920','108','351','512','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10080','pikachu-rock-star','25','60','4','112','37','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10081','pikachu-belle','25','60','4','112','38','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10082','pikachu-pop-star','25','60','4','112','39','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10083','pikachu-phd','25','60','4','112','40','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10084','pikachu-libre','25','60','4','112','41','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10085','pikachu-cosplay','25','60','4','112','36','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10086','hoopa-unbound','720','4900','65','306','866','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10087','camerupt-mega','323','3205','25','196','435','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10088','lopunny-mega','428','283','13','203','559','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10089','salamence-mega','373','1126','18','315','495','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10090','beedrill-mega','15','405','14','223','20','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10091','rattata-alola','19','38','3','51','26','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10092','raticate-alola','20','255','7','145','28','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10093','raticate-totem-alola','20','1050','14','145','29','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10094','pikachu-original-cap','25','60','4','112','42','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10095','pikachu-hoenn-cap','25','60','4','112','43','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10096','pikachu-sinnoh-cap','25','60','4','112','44','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10097','pikachu-unova-cap','25','60','4','112','45','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10098','pikachu-kalos-cap','25','60','4','112','46','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10099','pikachu-alola-cap','25','60','4','112','47','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10100','raichu-alola','26','210','7','243','52','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10101','sandshrew-alola','27','400','7','60','54','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10102','sandslash-alola','28','550','12','158','56','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10103','vulpix-alola','37','99','6','60','67','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10104','ninetales-alola','38','199','11','177','69','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10105','diglett-alola','50','10','2','53','85','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10106','dugtrio-alola','51','666','7','149','87','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10107','meowth-alola','52','42','4','58','89','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10108','persian-alola','53','330','11','154','92','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10109','geodude-alola','74','203','4','60','116','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10110','graveler-alola','75','1100','10','137','118','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10111','golem-alola','76','3160','17','223','120','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10112','grimer-alola','88','420','7','65','142','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10113','muk-alola','89','520','10','175','144','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10114','exeggutor-alola','103','4156','109','186','162','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10115','marowak-alola','105','340','10','149','165','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10116','greninja-battle-bond','658','400','15','239','789','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10117','greninja-ash','658','400','15','288','790','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10118','zygarde-10-power-construct','718','335','12','243','860','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10119','zygarde-50-power-construct','718','3050','50','300','861','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10120','zygarde-complete','718','6100','45','354','862','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10121','gumshoos-totem','735','600','14','146','882','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10122','vikavolt-totem','738','1475','26','225','886','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10123','oricorio-pom-pom','741','34','6','167','890','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10124','oricorio-pau','741','34','6','167','891','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10125','oricorio-sensu','741','34','6','167','892','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10126','lycanroc-midnight','745','250','11','170','899','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10127','wishiwashi-school','746','786','82','217','902','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10128','lurantis-totem','754','580','15','168','912','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10129','salazzle-totem','758','810','21','168','917','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10130','minior-orange-meteor','774','400','3','154','934','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10131','minior-yellow-meteor','774','400','3','154','935','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10132','minior-green-meteor','774','400','3','154','936','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10133','minior-blue-meteor','774','400','3','154','937','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10134','minior-indigo-meteor','774','400','3','154','938','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10135','minior-violet-meteor','774','400','3','154','939','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10136','minior-red','774','3','3','175','940','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10137','minior-orange','774','3','3','175','941','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10138','minior-yellow','774','3','3','175','942','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10139','minior-green','774','3','3','175','943','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10140','minior-blue','774','3','3','175','944','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10141','minior-indigo','774','3','3','175','945','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10142','minior-violet','774','3','3','175','946','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10143','mimikyu-busted','778','7','2','167','952','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10144','mimikyu-totem-disguised','778','28','4','167','953','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10145','mimikyu-totem-busted','778','28','4','167','954','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10146','kommo-o-totem','784','2075','24','270','961','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10147','magearna-original','801','805','10','300','982','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10148','pikachu-partner-cap','25','60','4','112','48','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10149','marowak-totem','105','980','17','149','166','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10150','ribombee-totem','743','20','4','162','895','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10151','rockruff-own-tempo','744','92','5','56','897','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10152','lycanroc-dusk','745','250','8','170','900','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10153','araquanid-totem','752','2175','31','159','909','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10154','togedemaru-totem','777','130','6','152','950','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10155','necrozma-dusk','800','4600','38','340','978','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10156','necrozma-dawn','800','3500','42','340','979','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10157','necrozma-ultra','800','2300','75','339','980','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10158','pikachu-starter','25','60','4','86','49','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10159','eevee-starter','133','65','3','87','216','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10160','pikachu-world-cap','25','60','4','112','50','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10161','meowth-galar','52','75','4','58','90','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10162','ponyta-galar','77','240','8','82','122','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10163','rapidash-galar','78','800','17','175','124','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10164','slowpoke-galar','79','360','12','63','126','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10165','slowbro-galar','80','705','16','172','129','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10166','farfetchd-galar','83','420','8','132','136','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10167','weezing-galar','110','160','30','172','175','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10168','mr-mime-galar','122','568','14','161','195','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10169','articuno-galar','144','509','17','290','237','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10170','zapdos-galar','145','582','16','290','239','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10171','moltres-galar','146','660','20','290','241','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10172','slowking-galar','199','795','18','172','131','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10173','corsola-galar','222','5','6','144','322','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10174','zigzagoon-galar','263','175','4','56','362','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10175','linoone-galar','264','325','5','147','364','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10176','darumaka-galar','554','400','7','63','672','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10177','darmanitan-galar-standard','555','1200','17','168','675','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10178','darmanitan-galar-zen','555','1200','17','189','676','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10179','yamask-galar','562','15','5','61','684','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10180','stunfisk-galar','618','205','7','165','741','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10181','zygarde-10','718','335','12','243','859','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10182','cramorant-gulping','845','180','8','166','1027','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10183','cramorant-gorging','845','180','8','166','1028','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10184','toxtricity-low-key','849','400','16','176','1033','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10185','eiscue-noice','875','890','14','165','1060','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10186','indeedee-female','876','280','9','166','1062','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10187','morpeko-hangry','877','30','3','153','1064','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10188','zacian-crowned','888','3550','28','360','1076','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10189','zamazenta-crowned','889','7850','29','360','1078','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10190','eternatus-eternamax','890','0','1000','563','1080','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10191','urshifu-rapid-strike','892','1050','19','275','1083','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10192','zarude-dada','893','700','18','300','1085','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10193','calyrex-ice','898','8091','24','340','1091','0');
INSERT INTO pokemon (id,name,species_id,height,weight,base_exp,"order",is_default) VALUES ('10194','calyrex-shadow','898','536','24','340','1092','0');
