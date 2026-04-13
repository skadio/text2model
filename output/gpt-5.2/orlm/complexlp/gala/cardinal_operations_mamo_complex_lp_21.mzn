% Diet / meal planning as an integer linear optimization problem
% Minimize total cost while meeting minimum nutrient requirements.

include "globals.mzn";

int: nFoods = 6;
set of int: FOODS = 1..nFoods;

array[FOODS] of string: name = ["Chicken","Rice","Vegetables","Bread","Almonds","Salmon"];

% Nutrients per unit of each food
array[FOODS] of int: protein = [16, 11,  1,  6,  2, 19];
array[FOODS] of int: carbs   = [ 8, 24,  5, 26, 11, 20];
array[FOODS] of int: calories= [50, 90,164,165, 51,238];

% Cost per unit
array[FOODS] of int: cost    = [ 2,  3,  3,  2,  4, 10];

% Minimum requirements
int: minProtein  = 58;
int: minCarbs    = 150;
int: minCalories = 2392;

% Decision variables: number of units of each food (nonnegative integers)
% Upper bounds chosen safely to cover feasible optima.
array[FOODS] of var 0..200: x;

var int: totalCost = sum(i in FOODS)(cost[i] * x[i]);

constraint sum(i in FOODS)(protein[i]  * x[i]) >= minProtein;
constraint sum(i in FOODS)(carbs[i]    * x[i]) >= minCarbs;
constraint sum(i in FOODS)(calories[i] * x[i]) >= minCalories;

solve minimize totalCost;

output [ show(totalCost) ];