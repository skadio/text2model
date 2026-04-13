% Parameters
int: N = 5;
set of int: FOODS = 1..N;

array[FOODS] of string: name = ["Chicken","Rice","Apples","Cheese","Tofu"];

array[FOODS] of int: protein = [14, 10, 4, 19, 10];
array[FOODS] of int: carbs   = [28, 27, 13, 5, 8];
array[FOODS] of int: calories= [184, 298, 162, 81, 147];
array[FOODS] of int: cost    = [5, 1, 5, 9, 9];

int: minProtein = 97;
int: minCarbs   = 140;
int: minCalories= 2304;

int: maxCost = sum(i in FOODS)(cost[i]) * 300; % safe upper bound

% Variables
array[FOODS] of var 0..300: x;   % number of servings of each food (non-negative integer)
var 0..maxCost: totalCost;

% Constraints
constraint sum(i in FOODS)(protein[i] * x[i])  >= minProtein;
constraint sum(i in FOODS)(carbs[i] * x[i])    >= minCarbs;
constraint sum(i in FOODS)(calories[i] * x[i]) >= minCalories;

constraint totalCost = sum(i in FOODS)(cost[i] * x[i]);

% Objective
solve minimize totalCost;