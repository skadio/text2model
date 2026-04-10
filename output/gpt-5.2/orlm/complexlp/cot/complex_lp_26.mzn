% Parameters (with values embedded)
int: nFoods = 8;
set of int: FOODS = 1..nFoods;

array[FOODS] of string: foodName =
  ["Chicken","Rice","Eggs","Beans","Spinach","Corn","Beef","Broccoli"];

array[FOODS] of int: protein = [5, 8, 18, 16, 3, 3, 6, 17];
array[FOODS] of int: carbs   = [15,17, 20, 15,28,19,24, 9];
array[FOODS] of int: calories= [162,282,234, 85,194,153,167,192];
array[FOODS] of int: cost    = [8, 4,  1,  4,  7, 2,  9,  3];

int: minProtein  = 68;
int: minCarbs    = 189;
int: minCalories = 1840;

% Variables
% x[i] = number of servings/units of food i to buy (nonnegative integer)
array[FOODS] of var 0..50: x;

var 0..(50 * sum(i in FOODS)(cost[i])): totalCost;

% Constraints
constraint totalCost = sum(i in FOODS)(cost[i] * x[i]);

constraint sum(i in FOODS)(protein[i]  * x[i]) >= minProtein;
constraint sum(i in FOODS)(carbs[i]    * x[i]) >= minCarbs;
constraint sum(i in FOODS)(calories[i] * x[i]) >= minCalories;

% Objective
solve minimize totalCost;