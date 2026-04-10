% Parameters
int: nFoods = 6;
set of int: FOODS = 1..nFoods;

array[FOODS] of int: cost = [1, 9, 2, 9, 4, 6];

array[FOODS] of int: protein = [13, 1, 17, 15, 2, 15];
array[FOODS] of int: carbs   = [27, 1, 2, 18, 19, 11];
array[FOODS] of int: calories= [81, 137, 53, 126, 117, 277];

int: minProtein = 58;
int: minCarbs   = 148;
int: minCalories= 2454;

% Variables
array[FOODS] of var 0..100: x;  % number of servings of each food (integer)

var 0..100000: totalCost;

% Constraints
constraint totalCost = sum(i in FOODS)(cost[i] * x[i]);

constraint sum(i in FOODS)(protein[i]  * x[i]) >= minProtein;
constraint sum(i in FOODS)(carbs[i]    * x[i]) >= minCarbs;
constraint sum(i in FOODS)(calories[i] * x[i]) >= minCalories;

% Objective
solve minimize totalCost;