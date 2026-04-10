% Parameters
int: N = 5;
set of int: FOODS = 1..N;

array[FOODS] of int: cost = [6, 1, 1, 3, 1];
array[FOODS] of int: protein = [1, 7, 6, 20, 8];
array[FOODS] of int: carbs = [3, 22, 18, 6, 4];
array[FOODS] of int: calories = [210, 96, 189, 132, 75];

int: min_protein = 87;
int: min_carbs = 135;
int: min_calories = 1926;

int: max_items = 1000;

% Variables
array[FOODS] of var 0..max_items: x;
var 0..(max_items * max(cost)): total_cost;

% Constraints
constraint total_cost = sum(i in FOODS)(cost[i] * x[i]);

constraint sum(i in FOODS)(protein[i] * x[i]) >= min_protein;
constraint sum(i in FOODS)(carbs[i] * x[i]) >= min_carbs;
constraint sum(i in FOODS)(calories[i] * x[i]) >= min_calories;

% Objective
solve minimize total_cost;