% Parameters
int: nFoods = 5;
set of int: FOODS = 1..nFoods;

array[FOODS] of int: protein = [20, 6, 17, 1, 10];
array[FOODS] of int: carbs   = [12, 29, 26, 8, 2];
array[FOODS] of int: calories= [167, 275, 112, 148, 286];
array[FOODS] of int: cost    = [7, 8, 2, 8, 2];

int: minProtein  = 83;
int: minCarbs    = 128;
int: minCalories = 1686;

int: maxUnits = 100;

% Variables
array[FOODS] of var 0..maxUnits: x;
var int: totalCost;

% Constraints
constraint sum(i in FOODS)(protein[i] * x[i])  >= minProtein;
constraint sum(i in FOODS)(carbs[i] * x[i])    >= minCarbs;
constraint sum(i in FOODS)(calories[i] * x[i]) >= minCalories;

constraint totalCost = sum(i in FOODS)(cost[i] * x[i]);

% Objective
solve minimize totalCost;