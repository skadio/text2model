% Parameters
int: n = 4;
set of int: FOODS = 1..n;

array[FOODS] of int: cost = [4, 4, 2, 4];
array[FOODS] of int: protein = [14, 5, 9, 10];
array[FOODS] of int: carbs = [7, 13, 26, 14];
array[FOODS] of int: calories = [208, 140, 280, 199];

int: req_protein = 74;
int: req_carbs = 166;
int: req_calories = 2210;

% Variables
array[FOODS] of var 0..100: x;
var 0..10000: total_cost;

% Constraints
constraint total_cost = sum(i in FOODS)(cost[i] * x[i]);

constraint sum(i in FOODS)(protein[i] * x[i]) >= req_protein;
constraint sum(i in FOODS)(carbs[i] * x[i]) >= req_carbs;
constraint sum(i in FOODS)(calories[i] * x[i]) >= req_calories;

% Objective
solve minimize total_cost;