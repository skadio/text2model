% Parameters
int: N = 5;
set of int: FOODS = 1..N;

array[FOODS] of int: cost    = [7, 6, 6, 10, 2];
array[FOODS] of int: protein = [13, 2, 7, 18, 12];
array[FOODS] of int: carbs   = [21, 30, 13, 8, 28];
array[FOODS] of int: calories= [284, 55, 276, 204, 160];

int: min_protein  = 79;
int: min_carbs    = 170;
int: min_calories = 1699;

int: max_units = 100; % safe upper bound

% Variables
array[FOODS] of var 0..max_units: x;
var 0..sum(i in FOODS)(cost[i]*max_units): total_cost;

% Constraints
constraint total_cost = sum(i in FOODS)(cost[i] * x[i]);

constraint sum(i in FOODS)(protein[i]  * x[i]) >= min_protein;
constraint sum(i in FOODS)(carbs[i]    * x[i]) >= min_carbs;
constraint sum(i in FOODS)(calories[i] * x[i]) >= min_calories;

% Objective
solve minimize total_cost;