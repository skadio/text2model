% Parameters
int: N = 6;
set of int: FOODS = 1..N;

array[FOODS] of int: protein = [18, 14, 18, 7, 15, 8];
array[FOODS] of int: carbs   = [5, 13, 4, 15, 17, 13];
array[FOODS] of int: calories= [202, 234, 220, 247, 88, 77];
array[FOODS] of int: cost    = [1, 7, 4, 3, 1, 2];

int: min_protein  = 70;
int: min_carbs    = 187;
int: min_calories = 2181;

int: max_units = 1000;

% Variables
array[FOODS] of var 0..max_units: x;
var 0..(max_units * sum(cost)): total_cost;

% Constraints
constraint total_cost = sum(i in FOODS)(cost[i] * x[i]);

constraint sum(i in FOODS)(protein[i] * x[i]) >= min_protein;
constraint sum(i in FOODS)(carbs[i]   * x[i]) >= min_carbs;
constraint sum(i in FOODS)(calories[i]* x[i]) >= min_calories;

% Objective
solve minimize total_cost;