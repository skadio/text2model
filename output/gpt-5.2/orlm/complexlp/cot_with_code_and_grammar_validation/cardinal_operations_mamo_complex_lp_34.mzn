% Parameters
int: nFoods = 7;
set of int: FOODS = 1..nFoods;

array[FOODS] of int: protein = [18, 12, 7, 17, 3, 4, 4];
array[FOODS] of int: carbs   = [23, 30, 16, 26, 30, 6, 23];
array[FOODS] of int: calories= [217, 182, 79, 295, 264, 160, 141];
array[FOODS] of int: cost    = [3, 10, 10, 7, 4, 6, 5];

int: targetProtein  = 59;
int: targetCarbs    = 160;
int: targetCalories = 1809;

int: maxServings = 1000;

% Variables
array[FOODS] of var 0..maxServings: x;
var 0..(maxServings * sum(cost)): totalCost;

% Constraints
constraint totalCost = sum(f in FOODS)(cost[f] * x[f]);

constraint sum(f in FOODS)(protein[f] * x[f])  >= targetProtein;
constraint sum(f in FOODS)(carbs[f] * x[f])    >= targetCarbs;
constraint sum(f in FOODS)(calories[f] * x[f]) >= targetCalories;

% Objective
solve minimize totalCost;