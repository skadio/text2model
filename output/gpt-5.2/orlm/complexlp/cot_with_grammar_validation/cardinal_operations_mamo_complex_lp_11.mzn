% Parameters
int: nFoods = 5;
set of int: FOODS = 1..nFoods;

array[FOODS] of string: foodName = ["Chicken","Pasta","Rice","Beans","Cheese"];

array[FOODS] of int: protein = [5, 3, 11, 10, 4];
array[FOODS] of int: carbs   = [13, 23, 27, 27, 18];
array[FOODS] of int: calories= [121,274,251,259,199];
array[FOODS] of int: cost    = [7, 10, 7, 9, 7];

int: minProtein = 60;
int: minCarbs   = 146;
int: minCalories= 1727;

% Variables
array[FOODS] of var 0..1000: x; % servings/units of each food (nonnegative integers)
var 0..1000000: totalCost;

% Constraints
constraint totalCost = sum(f in FOODS)(cost[f] * x[f]);

constraint sum(f in FOODS)(protein[f]  * x[f]) >= minProtein;
constraint sum(f in FOODS)(carbs[f]    * x[f]) >= minCarbs;
constraint sum(f in FOODS)(calories[f] * x[f]) >= minCalories;

% Objective
solve minimize totalCost;