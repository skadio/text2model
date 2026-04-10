% Parameters
int: N = 6;
set of int: FOODS = 1..N;

array[FOODS] of int: protein = [15, 20, 15, 19, 19, 12];
array[FOODS] of int: carbs   = [30, 16,  8,  5, 28, 17];
array[FOODS] of int: calories= [154,111,211, 87, 98,231];
array[FOODS] of int: cost    = [ 3,  8,  7,  2,  9, 10];

int: req_protein  = 73;
int: req_carbs    = 111;
int: req_calories = 2196;

int: max_qty = 1000;

% Variables
array[FOODS] of var 0..max_qty: x;
var 0..(max_qty * sum(cost)): total_cost;

% Constraints
constraint total_cost = sum(i in FOODS)(cost[i] * x[i]);

constraint sum(i in FOODS)(protein[i] * x[i])  >= req_protein;
constraint sum(i in FOODS)(carbs[i] * x[i])    >= req_carbs;
constraint sum(i in FOODS)(calories[i] * x[i]) >= req_calories;

% Objective
solve minimize total_cost;