% Parameters
int: nFoods = 9;
set of int: FOODS = 1..nFoods;

array[FOODS] of int: protein = [15, 1, 1, 6, 3, 17, 18, 12, 2];
array[FOODS] of int: carbs   = [18, 25, 21, 3, 7, 13, 27, 17, 30];
array[FOODS] of int: cal     = [300, 267, 266, 119, 166, 129, 216, 76, 258];
array[FOODS] of int: cost    = [4, 2, 5, 10, 2, 8, 10, 9, 4];

int: minProtein = 90;
int: minCarbs   = 105;
int: minCal     = 1805;

int: maxUnits = 100;

% Variables
array[FOODS] of var 0..maxUnits: x;
var 0..(maxUnits * sum(i in FOODS)(cost[i])): total_cost;

% Constraints
constraint total_cost = sum(i in FOODS)(cost[i] * x[i]);

constraint sum(i in FOODS)(protein[i] * x[i]) >= minProtein;
constraint sum(i in FOODS)(carbs[i] * x[i])   >= minCarbs;
constraint sum(i in FOODS)(cal[i] * x[i])     >= minCal;

% Objective
solve minimize total_cost;