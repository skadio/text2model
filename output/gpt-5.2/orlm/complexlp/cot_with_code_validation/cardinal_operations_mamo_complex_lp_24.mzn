% Parameters
int: nFoods = 6;
set of int: FOODS = 1..nFoods;

array[FOODS] of int: protein = [18, 14, 18, 7, 15, 8];
array[FOODS] of int: carbs   = [5, 13, 4, 15, 17, 13];
array[FOODS] of int: calories= [202, 234, 220, 247, 88, 77];
array[FOODS] of int: cost    = [1, 7, 4, 3, 1, 2];

int: minProtein  = 70;
int: minCarbs    = 187;
int: minCalories = 2181;

% Variables
array[FOODS] of var 0..2181: x; % servings/units of each food

var 0..(max(cost) * 2181): totalCost;

% Constraints
constraint forall(i in FOODS)(x[i] >= 0);

constraint sum(i in FOODS)(protein[i] * x[i]) >= minProtein;
constraint sum(i in FOODS)(carbs[i] * x[i])   >= minCarbs;
constraint sum(i in FOODS)(calories[i] * x[i])>= minCalories;

constraint totalCost = sum(i in FOODS)(cost[i] * x[i]);

% Objective
solve minimize totalCost;