% Parameters (with values embedded)
int: nFoods = 6;
set of int: FOODS = 1..nFoods;

array[FOODS] of string: foodName =
  ["Eggs","Chicken","Tofu","Salmon","Brown Rice","Spinach"];

array[FOODS] of int: protein = [1, 4, 13, 8, 7, 8];
array[FOODS] of int: carbs   = [13,10, 9, 3, 13,16];
array[FOODS] of int: calories= [211,256,273,54,93,52];
array[FOODS] of int: cost    = [10, 9, 2, 10, 8, 1];

int: minProtein  = 60;
int: minCarbs    = 122;
int: minCalories = 2028;

% Variables
array[FOODS] of var 0..1000: x; % number of servings of each food (integer, nonnegative)
var 0..100000: totalCost;

% Constraints
constraint sum(f in FOODS)(protein[f] * x[f]) >= minProtein;
constraint sum(f in FOODS)(carbs[f]   * x[f]) >= minCarbs;
constraint sum(f in FOODS)(calories[f]* x[f]) >= minCalories;

constraint totalCost = sum(f in FOODS)(cost[f] * x[f]);

% Objective
solve minimize totalCost;