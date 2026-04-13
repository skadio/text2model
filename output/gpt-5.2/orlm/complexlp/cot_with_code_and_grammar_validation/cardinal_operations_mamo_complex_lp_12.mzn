% Parameters
int: N = 4;
set of int: FOODS = 1..N;

array[FOODS] of int: protein = [2, 11, 19, 17];
array[FOODS] of int: carbs   = [9, 29, 16, 9];
array[FOODS] of int: calories= [165, 230, 68, 258];
array[FOODS] of int: cost    = [3, 3, 6, 9];

int: req_protein  = 88;
int: req_carbs    = 107;
int: req_calories = 1944;

% Variables
array[FOODS] of var 0..1000: x; % number of servings of each food (nonnegative integers)
var 0..100000: total_cost;

% Constraints
constraint total_cost = sum(i in FOODS)(cost[i] * x[i]);

constraint sum(i in FOODS)(protein[i]  * x[i]) >= req_protein;
constraint sum(i in FOODS)(carbs[i]    * x[i]) >= req_carbs;
constraint sum(i in FOODS)(calories[i] * x[i]) >= req_calories;

% Objective
solve minimize total_cost;