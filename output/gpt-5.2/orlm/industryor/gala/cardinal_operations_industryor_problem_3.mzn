% Farmer livestock profit maximization
% All data embedded as requested.

include "globals.mzn";

% Decision variables: numbers of each animal (nonnegative integers)
var 0..100: cows;
var 0..100: sheep;
var 0..50: chickens;   % at most 50 chickens

% Parameters
int: sell_cow = 500;   int: feed_cow = 100;
int: sell_sheep = 200; int: feed_sheep = 80;
int: sell_chicken = 8; int: feed_chicken = 5;

int: manure_cow = 10;
int: manure_sheep = 5;
int: manure_chicken = 3;

int: manure_cap = 800;
int: max_animals = 100;

int: min_cows = 10;
int: min_sheep = 20;

% Profit per animal
int: profit_cow = sell_cow - feed_cow;           % 400
int: profit_sheep = sell_sheep - feed_sheep;     % 120
int: profit_chicken = sell_chicken - feed_chicken; % 3

% Constraints
constraint cows >= min_cows;
constraint sheep >= min_sheep;

constraint cows + sheep + chickens <= max_animals;

constraint manure_cow * cows
         + manure_sheep * sheep
         + manure_chicken * chickens <= manure_cap;

% Objective
var int: total_profit =
    profit_cow * cows + profit_sheep * sheep + profit_chicken * chickens;

solve maximize total_profit;

output [
  "cows = ", show(cows), "\n",
  "sheep = ", show(sheep), "\n",
  "chickens = ", show(chickens), "\n",
  "total_animals = ", show(cows + sheep + chickens), "\n",
  "total_manure = ", show(manure_cow*cows + manure_sheep*sheep + manure_chicken*chickens), "\n",
  "total_profit = ", show(total_profit), "\n"
];