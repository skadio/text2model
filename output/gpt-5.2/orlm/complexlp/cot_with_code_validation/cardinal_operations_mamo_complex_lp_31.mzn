% Parameters
int: N = 6;
set of int: FOODS = 1..N;

array[FOODS] of int: protein = [20, 2, 10, 5, 17, 6];
array[FOODS] of int: carbs   = [9, 15, 30, 19, 12, 18];
array[FOODS] of int: cal     = [89, 276, 255, 258, 212, 246];
array[FOODS] of int: cost    = [6, 8, 4, 1, 3, 5];

int: req_protein = 90;
int: req_carbs   = 162;
int: req_cal     = 1926;

% Variables
array[FOODS] of var 0..1000: x;
var 0..100000: total_cost;

% Constraints
constraint total_cost = sum(i in FOODS)(cost[i] * x[i]);

constraint sum(i in FOODS)(protein[i] * x[i]) >= req_protein;
constraint sum(i in FOODS)(carbs[i]   * x[i]) >= req_carbs;
constraint sum(i in FOODS)(cal[i]     * x[i]) >= req_cal;

% Objective
solve minimize total_cost;