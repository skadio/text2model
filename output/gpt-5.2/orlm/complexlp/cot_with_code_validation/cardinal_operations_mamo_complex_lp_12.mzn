% Parameters
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
% Upper bound: at most max requirement if taking only the best-per-unit item (safe bound)
int: maxNeed = max([minProtein, minCarbs, minCalories]);
array[FOODS] of var 0..maxNeed: x;

var 0..(maxNeed * max(cost)): totalCost;

% Constraints
constraint totalCost = sum(i in FOODS)(cost[i] * x[i]);

constraint sum(i in FOODS)(protein[i]  * x[i]) >= minProtein;
constraint sum(i in FOODS)(carbs[i]    * x[i]) >= minCarbs;
constraint sum(i in FOODS)(calories[i] * x[i]) >= minCalories;

% Objective
solve minimize totalCost;