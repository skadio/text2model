% Parameters
int: nFoods = 6;
set of int: FOODS = 1..nFoods;

array[FOODS] of int: protein = [16, 11, 1, 6, 2, 19];
array[FOODS] of int: carbs   = [8, 24, 5, 26, 11, 20];
array[FOODS] of int: calories= [50, 90, 164, 165, 51, 238];
array[FOODS] of int: cost    = [2, 3, 3, 2, 4, 10];

int: reqProtein  = 58;
int: reqCarbs    = 150;
int: reqCalories = 2392;

% Variables
array[FOODS] of var 0..1000: x;
var 0..1000000: totalCost;

% Constraints
constraint totalCost = sum(i in FOODS)(cost[i] * x[i]);

constraint sum(i in FOODS)(protein[i] * x[i])  >= reqProtein;
constraint sum(i in FOODS)(carbs[i] * x[i])    >= reqCarbs;
constraint sum(i in FOODS)(calories[i] * x[i]) >= reqCalories;

% Objective
solve minimize totalCost;