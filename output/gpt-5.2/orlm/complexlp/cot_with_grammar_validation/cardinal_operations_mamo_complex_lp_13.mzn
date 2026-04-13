% Parameters
int: N = 5;
set of int: FOODS = 1..N;

array[FOODS] of int: cost = [4, 8, 7, 10, 1];          % Chicken, Rice, Broccoli, Tofu, Beans
array[FOODS] of int: protein = [18, 12, 13, 5, 10];     % grams
array[FOODS] of int: carbs = [6, 28, 19, 16, 20];       % grams
array[FOODS] of int: calories = [142, 88, 137, 141, 150];

int: req_protein = 56;
int: req_carbs = 194;
int: req_calories = 2012;

% Simple safe upper bounds (only needed for variable domains)
int: max_units_protein = max([ (req_protein + protein[i] - 1) div protein[i] | i in FOODS where protein[i] > 0 ]);
int: max_units_carbs   = max([ (req_carbs   + carbs[i]   - 1) div carbs[i]   | i in FOODS where carbs[i] > 0 ]);
int: max_units_cal     = max([ (req_calories+ calories[i]- 1) div calories[i]| i in FOODS where calories[i] > 0 ]);
int: U = max([max_units_protein, max_units_carbs, max_units_cal]);

% Variables
array[FOODS] of var 0..U: x; % number of units/servings of each food
var 0..(U * sum(cost)): total_cost;

% Constraints
constraint total_cost = sum(i in FOODS)(cost[i] * x[i]);

constraint sum(i in FOODS)(protein[i] * x[i]) >= req_protein;
constraint sum(i in FOODS)(carbs[i] * x[i]) >= req_carbs;
constraint sum(i in FOODS)(calories[i] * x[i]) >= req_calories;

% Objective
solve minimize total_cost;