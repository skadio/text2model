% Parameters
int: price_cow = 500;
int: price_sheep = 200;
int: price_chicken = 8;

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
int: max_total_animals = 100;

int: profit_cow = price_cow - feed_cow;
int: profit_sheep = price_sheep - feed_sheep;
int: profit_chicken = price_chicken - feed_chicken;

% Variables
var min_cows..max_total_animals: cows;
var min_sheep..max_total_animals: sheep;
var 0..max_chickens: chickens;

var 0..max_total_animals: total_animals;
var 0..manure_capacity: total_manure;

var 0..(profit_cow*max_total_animals + profit_sheep*max_total_animals + profit_chicken*max_chickens): total_profit;

% Constraints
constraint total_animals = cows + sheep + chickens;
constraint total_animals <= max_total_animals;

constraint total_manure = manure_cow*cows + manure_sheep*sheep + manure_chicken*chickens;
constraint total_manure <= manure_capacity;

constraint total_profit = profit_cow*cows + profit_sheep*sheep + profit_chicken*chickens;

% Objective
solve maximize total_profit;