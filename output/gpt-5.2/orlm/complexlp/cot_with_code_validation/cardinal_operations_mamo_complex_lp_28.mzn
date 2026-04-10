% Parameters
int: N = 9;
set of int: FOODS = 1..N;

array[FOODS] of int: cost = [5, 6, 5, 4, 1, 6, 1, 2, 7];
array[FOODS] of int: protein = [18, 2, 7, 20, 5, 13, 15, 20, 9];
array[FOODS] of int: carbs = [13, 25, 30, 16, 6, 9, 18, 18, 14];
array[FOODS] of int: calories = [233, 251, 191, 231, 111, 275, 99, 210, 74];

int: minProtein = 68;
int: minCarbs = 151;
int: minCalories = 1900;

int: maxServings = 100;

% Variables
array[FOODS] of var 0..maxServings: x;
var 0..(maxServings * sum(cost)): totalCost;

% Constraints
constraint totalCost = sum(i in FOODS)(cost[i] * x[i]);

constraint sum(i in FOODS)(protein[i] * x[i]) >= minProtein;
constraint sum(i in FOODS)(carbs[i] * x[i]) >= minCarbs;
constraint sum(i in FOODS)(calories[i] * x[i]) >= minCalories;

% Objective
solve minimize totalCost;