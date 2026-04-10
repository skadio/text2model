% Parameters
int: nFoods = 9;
set of int: FOODS = 1..nFoods;

array[FOODS] of int: cost = [10, 2, 7, 8, 4, 9, 2, 9, 9];
array[FOODS] of int: protein = [7, 12, 14, 9, 11, 10, 10, 9, 8];
array[FOODS] of int: carbs = [17, 12, 27, 6, 19, 23, 6, 16, 25];
array[FOODS] of int: calories = [95, 233, 134, 109, 202, 148, 184, 136, 229];

int: minProtein = 71;
int: minCarbs = 107;
int: minCalories = 1623;

int: maxUnits = 100;

% Variables
array[FOODS] of var 0..maxUnits: x;
var 0..(maxUnits * sum(f in FOODS)(cost[f])): totalCost;

% Constraints
constraint totalCost = sum(f in FOODS)(cost[f] * x[f]);

constraint sum(f in FOODS)(protein[f] * x[f]) >= minProtein;
constraint sum(f in FOODS)(carbs[f] * x[f]) >= minCarbs;
constraint sum(f in FOODS)(calories[f] * x[f]) >= minCalories;

% Objective
solve minimize totalCost;