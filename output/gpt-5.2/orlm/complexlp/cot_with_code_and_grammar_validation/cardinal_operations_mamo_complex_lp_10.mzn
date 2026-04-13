% Parameters
int: n = 5;
set of int: FOODS = 1..n;

array[FOODS] of int: protein = [20, 6, 17, 1, 10];
array[FOODS] of int: carbs   = [12, 29, 26, 8, 2];
array[FOODS] of int: calories= [167, 275, 112, 148, 286];
array[FOODS] of int: cost    = [7, 8, 2, 8, 2];

int: req_protein  = 83;
int: req_carbs    = 128;
int: req_calories = 1686;

int: max_units = max([
  (req_protein + min(protein) - 1) div min(protein),
  (req_carbs + min(carbs) - 1) div min(carbs),
  (req_calories + min(calories) - 1) div min(calories)
]);

% Variables
array[FOODS] of var 0..max_units: x;
var 0..(max_units * sum(cost)): total_cost;

% Constraints
constraint sum(i in FOODS)(protein[i] * x[i]) >= req_protein;
constraint sum(i in FOODS)(carbs[i] * x[i])   >= req_carbs;
constraint sum(i in FOODS)(calories[i] * x[i])>= req_calories;

constraint total_cost = sum(i in FOODS)(cost[i] * x[i]);

% Objective
solve minimize total_cost;