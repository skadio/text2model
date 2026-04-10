% Parameters
int: nFoods = 4;
set of int: FOODS = 1..nFoods;

array[FOODS] of int: protein = [2, 11, 19, 17];
array[FOODS] of int: carbs   = [9, 29, 16, 9];
array[FOODS] of int: cal     = [165, 230, 68, 258];
array[FOODS] of int: cost    = [3, 3, 6, 9];

int: reqProtein = 88;
int: reqCarbs   = 107;
int: reqCal     = 1944;

int: maxUnits = 1000;

% Variables
array[FOODS] of var 0..maxUnits: x;
var 0..(maxUnits * sum(cost)): totalCost;

% Constraints
constraint totalCost = sum(i in FOODS)(cost[i] * x[i]);

constraint sum(i in FOODS)(protein[i] * x[i]) >= reqProtein;
constraint sum(i in FOODS)(carbs[i]   * x[i]) >= reqCarbs;
constraint sum(i in FOODS)(cal[i]     * x[i]) >= reqCal;

% Objective
solve minimize totalCost;