% Parameters
int: nFoods = 6;
set of int: FOODS = 1..nFoods;

array[FOODS] of int: protein = [20, 2, 10, 5, 17, 6];
array[FOODS] of int: carbs   = [9, 15, 30, 19, 12, 18];
array[FOODS] of int: calories= [89, 276, 255, 258, 212, 246];
array[FOODS] of int: cost    = [6, 8, 4, 1, 3, 5];

int: reqProtein  = 90;
int: reqCarbs    = 162;
int: reqCalories = 1926;

% Variables
array[FOODS] of var 0..1000: x; % number of servings/units of each food
var 0..1000000: totalCost;

% Constraints
constraint totalCost = sum(i in FOODS)(cost[i] * x[i]);

constraint sum(i in FOODS)(protein[i] * x[i]) >= reqProtein;
constraint sum(i in FOODS)(carbs[i] * x[i])   >= reqCarbs;
constraint sum(i in FOODS)(calories[i] * x[i])>= reqCalories;

% Objective
solve minimize totalCost;