% Parameters
int: nFoods = 8;
set of int: FOODS = 1..nFoods;

array[FOODS] of int: cost = [4, 3, 2, 4, 9, 3, 6, 6];
array[FOODS] of int: protein = [2, 7, 6, 16, 20, 6, 6, 5];
array[FOODS] of int: carbs = [4, 9, 18, 3, 11, 27, 30, 1];
array[FOODS] of int: calories = [282, 104, 71, 116, 175, 132, 251, 74];

int: minProtein = 84;
int: minCarbs = 195;
int: minCalories = 1941;

% Variables
array[FOODS] of var 0..minCalories: x;
var 0..(minCalories * max(cost)): totalCost;

% Constraints
constraint forall(i in FOODS)(x[i] >= 0);

constraint sum(i in FOODS)(protein[i] * x[i]) >= minProtein;
constraint sum(i in FOODS)(carbs[i] * x[i]) >= minCarbs;
constraint sum(i in FOODS)(calories[i] * x[i]) >= minCalories;

constraint totalCost = sum(i in FOODS)(cost[i] * x[i]);

% Objective
solve minimize totalCost;