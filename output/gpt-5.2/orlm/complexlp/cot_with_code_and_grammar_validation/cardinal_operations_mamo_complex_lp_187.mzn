% Parameters
int: nFoods = 4;
set of int: FOODS = 1..nFoods;

array[FOODS] of int: protein = [4, 6, 20, 1];
array[FOODS] of int: carbs   = [7, 10, 0, 30];
array[FOODS] of int: calories= [130, 120, 150, 70];
array[FOODS] of int: cost    = [3, 4, 8, 2];

int: minProtein  = 30;
int: minCarbs    = 40;
int: minCalories = 400;

int: maxUnits = 100; % safe upper bound for servings of any food

% Variables
array[FOODS] of var 0..maxUnits: x; % number of servings of each food (integer)

var 0..(maxUnits * max(cost)): totalCost;

% Constraints
constraint totalCost = sum(i in FOODS)(cost[i] * x[i]);

constraint sum(i in FOODS)(protein[i] * x[i]) >= minProtein;
constraint sum(i in FOODS)(carbs[i]   * x[i]) >= minCarbs;
constraint sum(i in FOODS)(calories[i]* x[i]) >= minCalories;

% Objective
solve minimize totalCost;