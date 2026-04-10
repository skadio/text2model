% Parameters
int: N = 6;
set of int: FOODS = 1..N;

array[FOODS] of int: protein = [14, 11, 8, 1, 16, 19];
array[FOODS] of int: carbs   = [1,  6,  12,17, 11, 13];
array[FOODS] of int: calories= [164,210,98, 92, 211,211];
array[FOODS] of int: cost    = [6,  2,  9, 3,  7,  9];

int: minProtein  = 70;
int: minCarbs    = 117;
int: minCalories = 1837;

int: maxCost = minCalories * max([cost[i] | i in FOODS]);

% Variables
array[FOODS] of var 0..minCalories: x;
var 0..maxCost: totalCost;

% Constraints
constraint totalCost = sum(i in FOODS)(cost[i] * x[i]);

constraint sum(i in FOODS)(protein[i] * x[i]) >= minProtein;
constraint sum(i in FOODS)(carbs[i] * x[i])   >= minCarbs;
constraint sum(i in FOODS)(calories[i] * x[i])>= minCalories;

% Objective
solve minimize totalCost;

output [show(totalCost)];