% Parameters
int: sell_price_cow = 500;        % selling price per cow
int: sell_price_sheep = 200;      % selling price per sheep
int: sell_price_chicken = 8;      % selling price per chicken

int: feed_cost_cow = 100;         % feed cost per cow
int: feed_cost_sheep = 80;        % feed cost per sheep
int: feed_cost_chicken = 5;       % feed cost per chicken

int: profit_cow = sell_price_cow - feed_cost_cow;               % profit per cow
int: profit_sheep = sell_price_sheep - feed_cost_sheep;         % profit per sheep
int: profit_chicken = sell_price_chicken - feed_cost_chicken;   % profit per chicken

int: manure_cow = 10;             % manure units/day per cow
int: manure_sheep = 5;            % manure units/day per sheep
int: manure_chicken = 3;          % manure units/day per chicken

int: manure_capacity = 800;       % max manure units/day staff can handle
int: max_chickens = 50;           % maximum number of chickens due to farm size
int: min_cows = 10;               % minimum cows to meet demand
int: min_sheep = 20;              % minimum sheep required
int: max_total_animals = 100;     % maximum total animals allowed

% Variables
var min_cows..max_total_animals: num_cows;          % number of cows to raise
var min_sheep..max_total_animals: num_sheep;        % number of sheep to raise
var 0..max_chickens: num_chickens;                  % number of chickens to raise

% Total profit (upper bound is a safe over-estimate based on variable maxima)
var 0..(profit_cow*max_total_animals + profit_sheep*max_total_animals + profit_chicken*max_chickens): total_profit;

% Constraints
% Manure capacity constraint: total manure produced per day must not exceed staff capacity
constraint
  manure_cow * num_cows + manure_sheep * num_sheep + manure_chicken * num_chickens
  <= manure_capacity;

% Total animal count constraint: total number of animals raised cannot exceed the farm limit
constraint
  num_cows + num_sheep + num_chickens <= max_total_animals;

% Profit definition constraint: total_profit equals sum of per-animal profits
constraint
  total_profit =
    profit_cow * num_cows + profit_sheep * num_sheep + profit_chicken * num_chickens;

% Objective
solve maximize total_profit;