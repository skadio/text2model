% Parameters
int: nFoods = 6;
set of int: FOODS = 1..nFoods;

array[FOODS] of int: protein = [16, 11, 1, 6, 2, 19];
array[FOODS] of int: carbs   = [8, 24, 5, 26, 11, 20];
array[FOODS] of int: calories= [50, 90, 164, 165, 51, 238];
array[FOODS] of int: cost    = [2, 3, 3, 2, 4, 10];

int: minProtein  = 58;
int: minCarbs    = 150;
int: minCalories = 2392;

% Variables
array[FOODS] of var 0..2392: x;

var 0..(max(cost) * 2392): total_cost;

% Constraints
constraint sum(i in FOODS)(protein[i] * x[i]) >= minProtein;
constraint sum(i in FOODS)(carbs[i] * x[i])   >= minCarbs;
constraint sum(i in FOODS)(calories[i] * x[i])>= minCalories;

constraint total_cost = sum(i in FOODS)(cost[i] * x[i]);

% Objective
solve minimize total_cost;