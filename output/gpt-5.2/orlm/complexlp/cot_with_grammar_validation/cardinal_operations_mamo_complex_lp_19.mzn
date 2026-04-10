% Parameters
int: nFoods = 4;
set of int: FOODS = 1..nFoods;

array[FOODS] of int: cost = [6, 10, 1, 7];
array[FOODS] of int: protein = [4, 1, 10, 8];
array[FOODS] of int: carbs = [13, 13, 29, 26];
array[FOODS] of int: calories = [238, 85, 146, 139];

int: reqProtein = 93;
int: reqCarbs = 165;
int: reqCalories = 1553;

% Variables
array[FOODS] of var 0..1000: x;   % number of servings/units of each food
var 0..100000: totalCost;

% Constraints
constraint totalCost = sum(f in FOODS)(cost[f] * x[f]);

constraint sum(f in FOODS)(protein[f] * x[f]) >= reqProtein;
constraint sum(f in FOODS)(carbs[f] * x[f]) >= reqCarbs;
constraint sum(f in FOODS)(calories[f] * x[f]) >= reqCalories;

% Objective
solve minimize totalCost;