% Parameters
int: sell_cow = 500;
int: sell_sheep = 200;
int: sell_chicken = 8;

int: feed_cow = 100;
int: feed_sheep = 80;
int: feed_chicken = 5;

int: manure_cow = 10;
int: manure_sheep = 5;
int: manure_chicken = 3;

int: manure_cap = 800;

int: max_chickens = 50;
int: min_cows = 10;
int: min_sheep = 20;
int: max_animals = 100;

int: profit_cow = sell_cow - feed_cow;
int: profit_sheep = sell_sheep - feed_sheep;
int: profit_chicken = sell_chicken - feed_chicken;

% Variables
var min_cows..max_animals: cows;
var min_sheep..max_animals: sheep;
var 0..max_chickens: chickens;

var 0..(profit_cow*max_animals + profit_sheep*max_animals + profit_chicken*max_chickens): total_profit;

% Constraints
constraint manure_cow * cows + manure_sheep * sheep + manure_chicken * chickens <= manure_cap;

constraint cows + sheep + chickens <= max_animals;

constraint total_profit = profit_cow * cows + profit_sheep * sheep + profit_chicken * chickens;

% Objective
solve maximize total_profit;