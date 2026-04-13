% Parameters
int: n = 9;
set of int: FOODS = 1..n;

array[FOODS] of int: cost = [10, 2, 7, 8, 4, 9, 2, 9, 9];
array[FOODS] of int: protein = [7, 12, 14, 9, 11, 10, 10, 9, 8];
array[FOODS] of int: carbs   = [17, 12, 27, 6, 19, 23, 6, 16, 25];
array[FOODS] of int: calories= [95, 233, 134, 109, 202, 148, 184, 136, 229];

int: req_protein = 71;
int: req_carbs   = 107;
int: req_calories= 1623;

% Variables
array[FOODS] of var 0..20: x; % servings of each food item (bounded to ensure finite search)
var 0..10000: total_cost;

% Constraints
constraint total_cost = sum(i in FOODS)(cost[i] * x[i]);

constraint sum(i in FOODS)(protein[i] * x[i])  >= req_protein;
constraint sum(i in FOODS)(carbs[i] * x[i])    >= req_carbs;
constraint sum(i in FOODS)(calories[i] * x[i]) >= req_calories;

% Objective
solve minimize total_cost;