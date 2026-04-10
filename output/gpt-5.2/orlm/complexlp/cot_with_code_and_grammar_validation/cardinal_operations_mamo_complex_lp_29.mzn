% Parameters
int: nFoods = 4;
set of int: FOODS = 1..nFoods;

array[FOODS] of string: foodName = ["Chicken", "Tofu", "Rice", "Avocado"];

array[FOODS] of int: protein = [2, 18, 2, 18];
array[FOODS] of int: carbs   = [4, 17, 28, 27];
array[FOODS] of int: calories= [218, 290, 298, 158];
array[FOODS] of int: cost    = [3, 6, 1, 10];

int: minProtein  = 86;
int: minCarbs    = 120;
int: minCalories = 2435;

% Variables
array[FOODS] of var 0..1000: x; % servings/units of each food (non-negative integers)
var 0..100000: totalCost;

% Constraints
constraint totalCost = sum(f in FOODS)(cost[f] * x[f]);

constraint sum(f in FOODS)(protein[f]  * x[f]) >= minProtein;
constraint sum(f in FOODS)(carbs[f]    * x[f]) >= minCarbs;
constraint sum(f in FOODS)(calories[f] * x[f]) >= minCalories;

% Objective
solve minimize totalCost;