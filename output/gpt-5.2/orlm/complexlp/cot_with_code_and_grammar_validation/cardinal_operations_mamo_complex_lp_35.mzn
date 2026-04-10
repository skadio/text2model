% Parameters
int: N = 7;
set of int: FOODS = 1..N;

array[FOODS] of int: cost = [6, 2, 10, 6, 4, 1, 9];
array[FOODS] of int: protein = [6, 16, 12, 9, 12, 12, 13];
array[FOODS] of int: carbs = [3, 3, 17, 28, 17, 14, 20];
array[FOODS] of int: calories = [73, 181, 231, 160, 209, 184, 118];

int: req_protein = 59;
int: req_carbs = 179;
int: req_calories = 2414;

int: max_qty = 1000;

% Variables
array[FOODS] of var 0..max_qty: x;
var 0..sum(f in FOODS)(cost[f] * max_qty): total_cost;

% Constraints
constraint total_cost = sum(f in FOODS)(cost[f] * x[f]);

constraint sum(f in FOODS)(protein[f] * x[f]) >= req_protein;
constraint sum(f in FOODS)(carbs[f] * x[f]) >= req_carbs;
constraint sum(f in FOODS)(calories[f] * x[f]) >= req_calories;

% Objective
solve minimize total_cost;