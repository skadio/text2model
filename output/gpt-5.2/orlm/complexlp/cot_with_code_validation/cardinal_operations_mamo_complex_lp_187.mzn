% Parameters
int: nFoods = 4;
set of int: FOODS = 1..nFoods;

array[FOODS] of int: protein = [4, 6, 20, 1];
array[FOODS] of int: carbs   = [7, 10, 0, 30];
array[FOODS] of int: calories= [130, 120, 150, 70];
array[FOODS] of int: cost    = [3, 4, 8, 2];

int: minProtein = 30;
int: minCarbs   = 40;
int: minCalories= 400;

% Variables
% Use integer servings to ensure "rounded to the nearest dollar" is meaningful
array[FOODS] of var 0..100: x;          % servings of each food
var 0..100000: totalCost;

% Constraints
constraint totalCost = sum(f in FOODS)(cost[f] * x[f]);

constraint sum(f in FOODS)(protein[f]  * x[f]) >= minProtein;
constraint sum(f in FOODS)(carbs[f]    * x[f]) >= minCarbs;
constraint sum(f in FOODS)(calories[f] * x[f]) >= minCalories;

% Objective
solve minimize totalCost;