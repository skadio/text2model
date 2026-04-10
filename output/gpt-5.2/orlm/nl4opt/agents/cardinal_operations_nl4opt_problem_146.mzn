% Parameters
% Resource usage per pizza
int: dough_per_large = 12;
int: toppings_per_large = 5;
int: bake_time_large = 12;    % minutes

int: dough_per_medium = 8;
int: toppings_per_medium = 4;
int: bake_time_medium = 8;    % minutes

% Minimum requirements / policy constraints
int: min_total_dough = 10000;
int: min_total_toppings = 4400;
int: min_medium = 200;           % at least 200 medium pizzas
int: large_to_medium_factor = 2; % large >= 2 * medium


% Variables
var int: large_pizzas;    % number of large pizzas to make
var int: medium_pizzas;   % number of medium pizzas to make

% Total baking time (objective-related variable)
var int: total_bake_time;


% Constraints
% --- Bounds / feasibility constraints ---
constraint large_pizzas >= 0;
constraint medium_pizzas >= 0;

% --- Define total baking time ---
constraint total_bake_time =
    bake_time_large * large_pizzas
  + bake_time_medium * medium_pizzas;

% (Optional) ensure nonnegative total time
constraint total_bake_time >= 0;

% --- Resource minimums: ensure enough dough and toppings are used ---
constraint
  dough_per_large * large_pizzas + dough_per_medium * medium_pizzas >= min_total_dough;

constraint
  toppings_per_large * large_pizzas + toppings_per_medium * medium_pizzas >= min_total_toppings;

% --- Demand / policy constraints: promotion and regulars' preferences ---
constraint medium_pizzas >= min_medium;

constraint large_pizzas >= large_to_medium_factor * medium_pizzas;


% Objective
solve minimize total_bake_time;