% Parameters (with values embedded)
int: N = 6;
set of int: FOODS = 1..N;

array[FOODS] of int: cost = [4, 2, 6, 2, 6, 8];
array[FOODS] of int: protein = [17, 4, 7, 14, 13, 1];
array[FOODS] of int: carbs = [8, 24, 27, 16, 1, 13];
array[FOODS] of int: calories = [237, 213, 133, 118, 136, 225];

int: req_protein = 76;
int: req_carbs = 173;
int: req_calories = 1751;

% Variables
% x[i] = number of servings/units of food i (nonnegative integer)
array[FOODS] of var 0..20: x;

% Constraints
constraint sum(i in FOODS)(protein[i] * x[i]) >= req_protein;
constraint sum(i in FOODS)(carbs[i] * x[i]) >= req_carbs;
constraint sum(i in FOODS)(calories[i] * x[i]) >= req_calories;

% Objective
solve minimize sum(i in FOODS)(cost[i] * x[i]);