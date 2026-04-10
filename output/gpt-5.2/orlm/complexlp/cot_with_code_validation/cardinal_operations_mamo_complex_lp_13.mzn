% Parameters
int: N = 5;
set of int: FOODS = 1..N;

array[FOODS] of int: protein = [18, 12, 13, 5, 10];
array[FOODS] of int: carbs   = [ 6, 28, 19,16, 20];
array[FOODS] of int: cal     = [142, 88,137,141,150];
array[FOODS] of int: cost    = [ 4,  8,  7, 10,  1];

int: req_protein = 56;
int: req_carbs   = 194;
int: req_cal     = 2012;

int: maxUnits = 1000;

% Variables
array[FOODS] of var 0..maxUnits: x;
var 0..(maxUnits * sum(cost)): total_cost;

% Constraints
constraint total_cost = sum(f in FOODS)(cost[f] * x[f]);

constraint sum(f in FOODS)(protein[f] * x[f]) >= req_protein;
constraint sum(f in FOODS)(carbs[f]   * x[f]) >= req_carbs;
constraint sum(f in FOODS)(cal[f]     * x[f]) >= req_cal;

% Objective
solve minimize total_cost;