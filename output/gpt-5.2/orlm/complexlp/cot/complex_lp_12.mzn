% Parameters (with values embedded)
int: nFoods = 4;
set of int: FOODS = 1..nFoods;

array[FOODS] of int: protein = [2, 11, 19, 17];
array[FOODS] of int: carbs   = [9, 29, 16, 9];
array[FOODS] of int: calories= [165, 230, 68, 258];
array[FOODS] of int: cost    = [3, 3, 6, 9];

int: minProtein  = 88;
int: minCarbs    = 107;
int: minCalories = 1944;

% Variables
array[FOODS] of var 0..1000: x;  % servings of each food (nonnegative integers)
var 0..100000: totalCost;

% Constraints
constraint totalCost = sum(f in FOODS)(cost[f] * x[f]);

constraint sum(f in FOODS)(protein[f] * x[f])  >= minProtein;
constraint sum(f in FOODS)(carbs[f] * x[f])    >= minCarbs;
constraint sum(f in FOODS)(calories[f] * x[f]) >= minCalories;

% Objective
solve minimize totalCost;