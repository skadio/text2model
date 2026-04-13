% Parameters
int: N = 8;
set of int: FOODS = 1..N;

array[FOODS] of int: cost = [7, 7, 1, 9, 6, 7, 2, 6];
array[FOODS] of int: protein = [12, 10, 11, 8, 16, 4, 4, 4];
array[FOODS] of int: carbs = [5, 1, 30, 26, 9, 25, 16, 20];
array[FOODS] of int: calories = [231, 210, 295, 211, 232, 146, 255, 205];

int: req_protein = 91;
int: req_carbs = 136;
int: req_calories = 1563;

int: max_servings = 1000;

% Variables
array[FOODS] of var 0..max_servings: x;
var int: total_cost;

% Constraints
constraint total_cost = sum(i in FOODS)(cost[i] * x[i]);

constraint sum(i in FOODS)(protein[i] * x[i]) >= req_protein;
constraint sum(i in FOODS)(carbs[i] * x[i]) >= req_carbs;
constraint sum(i in FOODS)(calories[i] * x[i]) >= req_calories;

% Objective
solve minimize total_cost;