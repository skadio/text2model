% Parameters
int: N = 6;
set of int: FOODS = 1..N;

array[FOODS] of int: cost    = [4, 10, 6, 1, 8, 6];
array[FOODS] of int: protein = [14, 11, 20, 6, 9, 20];
array[FOODS] of int: carbs   = [4, 17, 12, 20, 11, 19];
array[FOODS] of int: calories= [275, 151, 155, 106, 279, 93];

int: req_protein  = 78;
int: req_carbs    = 140;
int: req_calories = 1537;

int: max_servings = 100;

% Variables
array[FOODS] of var 0..max_servings: x;
var 0..sum(i in FOODS)(cost[i]*max_servings): total_cost;

% Constraints
constraint total_cost = sum(i in FOODS)(cost[i] * x[i]);

constraint sum(i in FOODS)(protein[i]  * x[i]) >= req_protein;
constraint sum(i in FOODS)(carbs[i]    * x[i]) >= req_carbs;
constraint sum(i in FOODS)(calories[i] * x[i]) >= req_calories;

% Objective
solve minimize total_cost;