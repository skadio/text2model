% Parameters
int: N = 5;
set of int: FOODS = 1..N;

array[FOODS] of int: protein = [20, 6, 17, 1, 10];
array[FOODS] of int: carbs   = [12, 29, 26, 8, 2];
array[FOODS] of int: calories= [167, 275, 112, 148, 286];
array[FOODS] of int: cost    = [7, 8, 2, 8, 2];

int: req_protein  = 83;
int: req_carbs    = 128;
int: req_calories = 1686;

% Variables
array[FOODS] of var 0..100: x; % servings of each food item (upper bound is safe)
var 0..100000: total_cost;

% Constraints
constraint total_cost = sum(i in FOODS)(cost[i] * x[i]);

constraint sum(i in FOODS)(protein[i] * x[i]) >= req_protein;
constraint sum(i in FOODS)(carbs[i]   * x[i]) >= req_carbs;
constraint sum(i in FOODS)(calories[i]* x[i]) >= req_calories;

% Objective
solve minimize total_cost;