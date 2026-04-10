% Parameters
int: N = 7;
set of int: FOODS = 1..N;

array[FOODS] of int: cost = [6, 2, 10, 6, 4, 1, 9];
array[FOODS] of int: protein = [6, 16, 12, 9, 12, 12, 13];
array[FOODS] of int: carbs = [3, 3, 17, 28, 17, 14, 20];
array[FOODS] of int: calories = [73, 181, 231, 160, 209, 184, 118];

int: min_protein = 59;
int: min_carbs = 179;
int: min_calories = 2414;

int: max_units = max([min_protein, min_carbs, min_calories]);

% Variables
array[FOODS] of var 0..max_units: x;
var 0..(max_units * max(cost)): total_cost;

% Constraints
constraint total_cost = sum(i in FOODS)(cost[i] * x[i]);

constraint sum(i in FOODS)(protein[i] * x[i]) >= min_protein;
constraint sum(i in FOODS)(carbs[i] * x[i]) >= min_carbs;
constraint sum(i in FOODS)(calories[i] * x[i]) >= min_calories;

% Objective
solve minimize total_cost;