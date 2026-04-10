% Parameters
int: n = 4;
set of int: FOODS = 1..n;

array[FOODS] of int: cost = [6, 10, 1, 7];
array[FOODS] of int: protein = [4, 1, 10, 8];
array[FOODS] of int: carbs = [13, 13, 29, 26];
array[FOODS] of int: calories = [238, 85, 146, 139];

int: min_protein = 93;
int: min_carbs = 165;
int: min_calories = 1553;

% Variables
array[FOODS] of var 0..1000: x; % number of units of each food item
var 0..100000: total_cost;

% Constraints
constraint total_cost = sum(i in FOODS)(cost[i] * x[i]);

constraint sum(i in FOODS)(protein[i] * x[i]) >= min_protein;
constraint sum(i in FOODS)(carbs[i] * x[i]) >= min_carbs;
constraint sum(i in FOODS)(calories[i] * x[i]) >= min_calories;

% Objective
solve minimize total_cost;