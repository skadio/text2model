% Parameters
int: nFoods = 5;
set of int: FOODS = 1..nFoods;

array[FOODS] of int: cost = [7, 6, 6, 10, 2];
array[FOODS] of int: protein = [13, 2, 7, 18, 12];
array[FOODS] of int: carbs = [21, 30, 13, 8, 28];
array[FOODS] of int: calories = [284, 55, 276, 204, 160];

int: reqProtein = 79;
int: reqCarbs = 170;
int: reqCalories = 1699;

% Variables
% x[i] = number of servings/units of food i
array[FOODS] of var 0..100: x;

var 0..10000: totalCost;

% Constraints
constraint totalCost = sum(i in FOODS)(cost[i] * x[i]);

constraint sum(i in FOODS)(protein[i] * x[i]) >= reqProtein;
constraint sum(i in FOODS)(carbs[i] * x[i]) >= reqCarbs;
constraint sum(i in FOODS)(calories[i] * x[i]) >= reqCalories;

% Objective
solve minimize totalCost;