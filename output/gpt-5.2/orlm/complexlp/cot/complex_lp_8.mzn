% Parameters (with values embedded)
int: nFoods = 9;
set of int: FOODS = 1..nFoods;

array[FOODS] of int: cost = [10, 2, 7, 8, 4, 9, 2, 9, 9];
array[FOODS] of int: protein = [7, 12, 14, 9, 11, 10, 10, 9, 8];
array[FOODS] of int: carbs   = [17, 12, 27, 6, 19, 23, 6, 16, 25];
array[FOODS] of int: calories= [95, 233, 134, 109, 202, 148, 184, 136, 229];

int: req_protein = 71;
int: req_carbs = 107;
int: req_calories = 1623;

% Variables
array[FOODS] of var 0..100: x;  % number of servings of each food item (bounded)

var int: total_cost = sum(i in FOODS)(cost[i] * x[i]);
var int: total_protein = sum(i in FOODS)(protein[i] * x[i]);
var int: total_carbs   = sum(i in FOODS)(carbs[i] * x[i]);
var int: total_calories= sum(i in FOODS)(calories[i] * x[i]);

% Constraints
constraint total_protein >= req_protein;
constraint total_carbs >= req_carbs;
constraint total_calories >= req_calories;

% Objective
solve minimize total_cost;

output [show(total_cost)];