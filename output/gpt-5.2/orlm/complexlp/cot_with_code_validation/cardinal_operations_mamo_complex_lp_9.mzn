% Parameters
int: nFoods = 8;
set of int: FOODS = 1..nFoods;

array[FOODS] of int: cost = [7, 7, 1, 9, 6, 7, 2, 6];
array[FOODS] of int: protein = [12, 10, 11, 8, 16, 4, 4, 4];
array[FOODS] of int: carbs = [5, 1, 30, 26, 9, 25, 16, 20];
array[FOODS] of int: calories = [231, 210, 295, 211, 232, 146, 255, 205];

int: reqProtein = 91;
int: reqCarbs = 136;
int: reqCalories = 1563;

% Variables
array[FOODS] of var 0..1000: x; % servings/units of each food item
var 0..1000000: totalCost;

% Constraints
constraint totalCost = sum(i in FOODS)(cost[i] * x[i]);

constraint sum(i in FOODS)(protein[i] * x[i]) >= reqProtein;
constraint sum(i in FOODS)(carbs[i] * x[i]) >= reqCarbs;
constraint sum(i in FOODS)(calories[i] * x[i]) >= reqCalories;

% Objective
solve minimize totalCost;