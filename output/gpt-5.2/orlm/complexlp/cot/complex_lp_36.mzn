% Parameters (with values embedded)
int: nFoods = 4;
set of int: FOODS = 1..nFoods;

array[FOODS] of string: foodName = ["Steak","Eggs","Pasta","Chicken"];

array[FOODS] of int: protein = [20, 7, 1, 10];
array[FOODS] of int: carbs   = [ 2, 3,26,  1];
array[FOODS] of int: calories= [68,143,52, 69];
array[FOODS] of int: cost    = [ 4,  1, 9,  4];

int: minProtein  = 71;
int: minCarbs    = 141;
int: minCalories = 1839;

% Variables
array[FOODS] of var 0..1839: x; % number of servings of each food (nonnegative integer)
var int: totalCost;

% Constraints
constraint sum(f in FOODS)(protein[f] * x[f]) >= minProtein;
constraint sum(f in FOODS)(carbs[f]   * x[f]) >= minCarbs;
constraint sum(f in FOODS)(calories[f]* x[f]) >= minCalories;

constraint totalCost = sum(f in FOODS)(cost[f] * x[f]);

% Objective
solve minimize totalCost;

output [show(totalCost)];