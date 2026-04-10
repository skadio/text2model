% Parameters
int: N = 9;
set of int: FOODS = 1..N;

array[FOODS] of int: cost = [5, 6, 5, 4, 1, 6, 1, 2, 7];
array[FOODS] of int: protein = [18, 2, 7, 20, 5, 13, 15, 20, 9];
array[FOODS] of int: carbs = [13, 25, 30, 16, 6, 9, 18, 18, 14];
array[FOODS] of int: calories = [233, 251, 191, 231, 111, 275, 99, 210, 74];

int: req_protein = 68;
int: req_carbs = 151;
int: req_calories = 1900;

int: max_units = 100;

% Variables
array[FOODS] of var 0..max_units: x;
var 0..(max_units * sum(i in FOODS)(cost[i])): total_cost;

% Constraints
constraint total_cost = sum(i in FOODS)(cost[i] * x[i]);

constraint sum(i in FOODS)(protein[i] * x[i]) >= req_protein;
constraint sum(i in FOODS)(carbs[i] * x[i]) >= req_carbs;
constraint sum(i in FOODS)(calories[i] * x[i]) >= req_calories;

% Objective
solve minimize total_cost;