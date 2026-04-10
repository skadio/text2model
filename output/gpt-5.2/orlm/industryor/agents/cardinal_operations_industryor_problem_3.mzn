% Parameters
% Selling price per animal
int: sell_price_cow = 500;
int: sell_price_sheep = 200;
int: sell_price_chicken = 8;

% Feed cost per animal
int: feed_cost_cow = 100;
int: feed_cost_sheep = 80;
int: feed_cost_chicken = 5;

% Manure production per day (units)
int: manure_cow = 10;
int: manure_sheep = 5;
int: manure_chicken = 3;

% Capacity / policy limits
int: manure_capacity = 800;     % max manure units that can be handled per day
int: max_chickens = 50;         % farm size limit for chickens
int: min_cows = 10;             % minimum cows to meet demand
int: min_sheep = 20;            % minimum sheep required
int: max_total_animals = 100;   % total animals limit

% Derived profit per animal (revenue minus feed cost)
int: profit_cow = sell_price_cow - feed_cost_cow;
int: profit_sheep = sell_price_sheep - feed_cost_sheep;
int: profit_chicken = sell_price_chicken - feed_cost_chicken;

% Variables
% Decision variables: number of each animal (bounded for efficiency)
var min_cows..max_total_animals: cows;
var min_sheep..max_total_animals: sheep;
var 0..max_chickens: chickens;

% Aggregates
var 0..max_total_animals: total_animals;   % total number of animals
var 0..manure_capacity: total_manure;      % total manure produced per day
var int: total_profit;                     % total profit (can be safely unbounded here)

% Constraints
% Total animals calculation and overall limit
constraint total_animals = cows + sheep + chickens;
constraint total_animals <= max_total_animals;

% Manure production calculation and daily handling capacity
constraint total_manure =
  manure_cow * cows + manure_sheep * sheep + manure_chicken * chickens;
constraint total_manure <= manure_capacity;

% Profit calculation
constraint total_profit =
  profit_cow * cows + profit_sheep * sheep + profit_chicken * chickens;

% Objective
solve maximize total_profit;