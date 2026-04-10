% Parameters
int: nFoods = 4;
set of int: FOODS = 1..nFoods;

array[FOODS] of string: foodName = ["Chicken","Rice","Broccoli","Eggs"];

array[FOODS] of int: protein = [17, 20, 3, 18];
array[FOODS] of int: carbs   = [6, 13, 25, 20];
array[FOODS] of int: calories= [94, 74, 73, 119];
array[FOODS] of int: cost    = [7, 10, 9, 2];

int: minProtein  = 84;
int: minCarbs    = 117;
int: minCalories = 1554;

% Variables
array[FOODS] of var 0..1000: x;  % number of servings of each food (integer)

var 0..100000: totalCost;

% Constraints
constraint totalCost = sum(i in FOODS)(cost[i] * x[i]);

constraint sum(i in FOODS)(protein[i] * x[i])  >= minProtein;
constraint sum(i in FOODS)(carbs[i] * x[i])    >= minCarbs;
constraint sum(i in FOODS)(calories[i] * x[i]) >= minCalories;

% Objective
solve minimize totalCost;