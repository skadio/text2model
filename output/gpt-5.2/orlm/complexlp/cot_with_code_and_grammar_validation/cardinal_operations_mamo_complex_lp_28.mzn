% Parameters
int: nFoods = 9;
set of int: FOODS = 1..nFoods;

array[FOODS] of int: cost = [5, 6, 5, 4, 1, 6, 1, 2, 7];
array[FOODS] of int: protein = [18, 2, 7, 20, 5, 13, 15, 20, 9];
array[FOODS] of int: carbs = [13, 25, 30, 16, 6, 9, 18, 18, 14];
array[FOODS] of int: calories = [233, 251, 191, 231, 111, 275, 99, 210, 74];

int: reqProtein = 68;
int: reqCarbs = 151;
int: reqCalories = 1900;

% Variables
array[FOODS] of var 0..100: x; % number of servings of each food
var 0..100000: totalCost;

% Constraints
constraint totalCost = sum(i in FOODS)(cost[i] * x[i]);

constraint sum(i in FOODS)(protein[i] * x[i]) >= reqProtein;
constraint sum(i in FOODS)(carbs[i] * x[i]) >= reqCarbs;
constraint sum(i in FOODS)(calories[i] * x[i]) >= reqCalories;

% Objective
solve minimize totalCost;