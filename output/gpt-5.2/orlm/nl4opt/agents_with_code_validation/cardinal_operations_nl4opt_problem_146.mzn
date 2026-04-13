% Parameters
% Resource requirements per pizza
int: dough_large = 12;
int: toppings_large = 5;
int: bake_large = 12;      % minutes

int: dough_medium = 8;
int: toppings_medium = 4;
int: bake_medium = 8;      % minutes

% Minimum required usage / production constraints
int: min_dough = 10000;
int: min_toppings = 4400;
int: min_medium = 200;
int: large_to_medium_ratio = 2; % large >= 2 * medium

% Useful upper bounds (derived to keep variables bounded)
% Producing more pizzas only increases baking time, so in an optimum we won't
% exceed what is needed to satisfy minimum resource usage (given the mix constraints).
int: max_large =
  max(ceil(min_dough / dough_large), ceil(min_toppings / toppings_large));
int: max_medium =
  max(ceil(min_dough / dough_medium), ceil(min_toppings / toppings_medium));


% Variables
var 0..max_large: n_large;            % number of large pizzas
var min_medium..max_medium: n_medium; % number of medium pizzas

% Total baking time (minutes)
var 0..(bake_large * max_large + bake_medium * max_medium): total_bake_time;


% Constraints
% --- Resource usage constraints (must meet minimum usage) ---
constraint dough_large * n_large + dough_medium * n_medium >= min_dough;
constraint toppings_large * n_large + toppings_medium * n_medium >= min_toppings;

% --- Demand / production mix constraints ---
constraint n_medium >= min_medium;  % (also ensured by variable domain)
constraint n_large >= large_to_medium_ratio * n_medium;

% --- Definition constraint for total baking time ---
constraint total_bake_time = bake_large * n_large + bake_medium * n_medium;


% Objective
solve minimize total_bake_time;