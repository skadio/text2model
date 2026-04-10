% Parameters
int: nFoods = 6;
set of int: FOODS = 1..nFoods;

array[FOODS] of int: protein = [14, 2, 17, 3, 15, 2];
array[FOODS] of int: carbs   = [23, 13, 13, 1, 23, 8];
array[FOODS] of int: calories= [63, 162, 260, 55, 231, 297];
array[FOODS] of int: cost    = [4, 6, 6, 8, 8, 5];

int: minProtein  = 83;
int: minCarbs    = 192;
int: minCalories = 2089;

% Variables
array[FOODS] of var 0..2089: x;  % servings/units of each food (nonnegative integers)
var 0..(max(cost)*2089): totalCost;

% Constraints
constraint forall(i in FOODS)(x[i] >= 0);

constraint sum(i in FOODS)(protein[i] * x[i])  >= minProtein;
constraint sum(i in FOODS)(carbs[i] * x[i])    >= minCarbs;
constraint sum(i in FOODS)(calories[i] * x[i]) >= minCalories;

constraint totalCost = sum(i in FOODS)(cost[i] * x[i]);

% Objective
solve minimize totalCost;