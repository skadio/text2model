% Parameters
int: n_foods = 5;                    % number of foods
set of int: FOODS = 1..n_foods;

% Food indices (for readability)
int: CHICKEN = 1;
int: RICE    = 2;
int: APPLES  = 3;
int: CHEESE  = 4;
int: TOFU    = 5;

array[FOODS] of int: cost     = [5, 1, 5, 9, 9];          % cost per unit
array[FOODS] of int: protein  = [14, 10, 4, 19, 10];      % grams protein per unit
array[FOODS] of int: carbs    = [28, 27, 13, 5, 8];       % grams carbs per unit
array[FOODS] of int: calories = [184, 298, 162, 81, 147]; % calories per unit

int: min_protein  = 97;
int: min_carbs    = 140;
int: min_calories = 2304;

% Variables
array[FOODS] of var 0..2304: x; % integer units of each food (safe upper bound)
var 0..(sum(i in FOODS)(cost[i] * 2304)): total_cost; % total cost to minimize

% Constraints
% Link total cost to chosen food quantities
constraint
  total_cost = sum(i in FOODS)(cost[i] * x[i]);

% Meet minimum protein requirement
constraint
  sum(i in FOODS)(protein[i] * x[i]) >= min_protein;

% Meet minimum carbohydrate requirement
constraint
  sum(i in FOODS)(carbs[i] * x[i]) >= min_carbs;

% Meet minimum calorie requirement
constraint
  sum(i in FOODS)(calories[i] * x[i]) >= min_calories;

% Objective
solve minimize total_cost;

output [ show(total_cost) ];