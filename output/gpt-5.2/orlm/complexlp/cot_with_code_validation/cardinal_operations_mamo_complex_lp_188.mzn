% Parameters
int: nFoods = 4;
set of int: FOODS = 1..nFoods;

array[FOODS] of int: protein = [4, 6, 20, 1];
array[FOODS] of int: carbs   = [7, 10, 0, 30];
array[FOODS] of int: calories= [130, 120, 150, 70];
array[FOODS] of int: cost    = [3, 4, 8, 2];

int: minProtein  = 40;
int: minCarbs    = 50;
int: minCalories = 450;

int: maxUnits = 100;

% Variables
array[FOODS] of var 0..maxUnits: x;  % number of units of each food
var 0..(maxUnits * sum(cost)): totalCost;

% Constraints
constraint totalCost = sum(f in FOODS)(cost[f] * x[f]);

constraint sum(f in FOODS)(protein[f]  * x[f]) >= minProtein;
constraint sum(f in FOODS)(carbs[f]    * x[f]) >= minCarbs;
constraint sum(f in FOODS)(calories[f] * x[f]) >= minCalories;

% Objective
solve minimize totalCost;