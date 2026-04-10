% Parameters
int: nFoods = 6;
set of int: FOODS = 1..nFoods;

array[FOODS] of int: cost = [4, 2, 6, 2, 6, 8];
array[FOODS] of int: protein = [17, 4, 7, 14, 13, 1];
array[FOODS] of int: carbs = [8, 24, 27, 16, 1, 13];
array[FOODS] of int: calories = [237, 213, 133, 118, 136, 225];

int: reqProtein = 76;
int: reqCarbs = 173;
int: reqCalories = 1751;

% Variables
array[FOODS] of var 0..100: x; % servings (nonnegative integers)
var int: totalCost;

% Constraints
constraint sum(i in FOODS)(protein[i] * x[i]) >= reqProtein;
constraint sum(i in FOODS)(carbs[i] * x[i]) >= reqCarbs;
constraint sum(i in FOODS)(calories[i] * x[i]) >= reqCalories;

constraint totalCost = sum(i in FOODS)(cost[i] * x[i]);

% Objective
solve minimize totalCost;