% Parameters
int: nFoods = 5;
set of int: FOODS = 1..nFoods;

array[FOODS] of int: protein = [5, 3, 11, 10, 4];
array[FOODS] of int: carbs   = [13, 23, 27, 27, 18];
array[FOODS] of int: calories= [121, 274, 251, 259, 199];
array[FOODS] of int: cost    = [7, 10, 7, 9, 7];

int: minProtein  = 60;
int: minCarbs    = 146;
int: minCalories = 1727;

% Variables
array[FOODS] of var 0..1727: x;          % number of servings of each food
var 0..(1727 * max(cost)): totalCost;

% Constraints
constraint forall(i in FOODS)(x[i] >= 0);

constraint sum(i in FOODS)(protein[i] * x[i])  >= minProtein;
constraint sum(i in FOODS)(carbs[i]   * x[i])  >= minCarbs;
constraint sum(i in FOODS)(calories[i]* x[i])  >= minCalories;

constraint totalCost = sum(i in FOODS)(cost[i] * x[i]);

% Objective
solve minimize totalCost;