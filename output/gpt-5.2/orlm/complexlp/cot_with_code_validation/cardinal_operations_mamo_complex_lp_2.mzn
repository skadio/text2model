% Parameters
int: N = 5;
set of int: FOODS = 1..N;

array[FOODS] of int: protein = [3, 17, 16, 8, 6];
array[FOODS] of int: carbs   = [16, 24, 27, 16, 6];
array[FOODS] of int: cal     = [96, 182, 114, 208, 236];
array[FOODS] of int: cost    = [9, 9, 2, 9, 5];

int: req_protein = 100;
int: req_carbs   = 180;
int: req_cal     = 1796;

int: max_units = 1000;

% Variables
array[FOODS] of var 0..max_units: x;
var 0..(max_units * sum(cost)): total_cost;

% Constraints
constraint total_cost = sum(i in FOODS)(cost[i] * x[i]);

constraint sum(i in FOODS)(protein[i] * x[i]) >= req_protein;
constraint sum(i in FOODS)(carbs[i]   * x[i]) >= req_carbs;
constraint sum(i in FOODS)(cal[i]     * x[i]) >= req_cal;

% Objective
solve minimize total_cost;