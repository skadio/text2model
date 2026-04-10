% Parameters
int: N = 6;
set of int: FOODS = 1..N;

array[FOODS] of int: protein = [13, 1, 17, 15, 2, 15];
array[FOODS] of int: carbs   = [27, 1, 2, 18, 19, 11];
array[FOODS] of int: calories= [81, 137, 53, 126, 117, 277];
array[FOODS] of int: cost    = [1, 9, 2, 9, 4, 6];

int: req_protein = 58;
int: req_carbs   = 148;
int: req_calories= 2454;

% Variables
int: max_units = req_calories; % safe upper bound using min calories per unit >= 1
array[FOODS] of var 0..max_units: x;

var 0..(max_units * max(cost)): total_cost;

% Constraints
constraint total_cost = sum(i in FOODS)(cost[i] * x[i]);

constraint sum(i in FOODS)(protein[i] * x[i]) >= req_protein;
constraint sum(i in FOODS)(carbs[i]   * x[i]) >= req_carbs;
constraint sum(i in FOODS)(calories[i]* x[i]) >= req_calories;

% Objective
solve minimize total_cost;