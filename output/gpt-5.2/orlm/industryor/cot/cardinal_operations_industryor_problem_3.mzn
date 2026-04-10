% Parameters (with values embedded)
int: sell_cow = 500;
int: sell_sheep = 200;
int: sell_chicken = 8;

int: feed_cow = 100;
int: feed_sheep = 80;
int: feed_chicken = 5;

int: manure_cow = 10;
int: manure_sheep = 5;
int: manure_chicken = 3;

int: manure_capacity = 800;
int: max_chickens = 50;
int: min_cows = 10;
int: min_sheep = 20;
int: max_animals = 100;

int: profit_cow = sell_cow - feed_cow;
int: profit_sheep = sell_sheep - feed_sheep;
int: profit_chicken = sell_chicken - feed_chicken;

% Variables
var 0..max_animals: cows;
var 0..max_animals: sheep;
var 0..max_chickens: chickens;

% Constraints
constraint cows >= min_cows;
constraint sheep >= min_sheep;
constraint chickens <= max_chickens;

constraint cows + sheep + chickens <= max_animals;

constraint manure_cow * cows + manure_sheep * sheep + manure_chicken * chickens <= manure_capacity;

% Objective
solve maximize profit_cow * cows + profit_sheep * sheep + profit_chicken * chickens;