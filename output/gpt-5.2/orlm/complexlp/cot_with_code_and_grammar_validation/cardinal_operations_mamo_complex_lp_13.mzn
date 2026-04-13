% Parameters
int: nFoods = 5;
set of int: FOODS = 1..nFoods;

array[FOODS] of int: cost = [4, 8, 7, 10, 1];

array[FOODS] of int: protein = [18, 12, 13, 5, 10];
array[FOODS] of int: carbs   = [6, 28, 19, 16, 20];
array[FOODS] of int: calories= [142, 88, 137, 141, 150];

int: req_protein  = 56;
int: req_carbs    = 194;
int: req_calories = 2012;

% Variables
% servings of each food item (non-negative integer)
array[FOODS] of var int: x;

var int: total_cost;

% Constraints
constraint forall(i in FOODS) (x[i] >= 0);

constraint sum(i in FOODS)(protein[i] * x[i]) >= req_protein;
constraint sum(i in FOODS)(carbs[i] * x[i])   >= req_carbs;
constraint sum(i in FOODS)(calories[i] * x[i])>= req_calories;

constraint total_cost = sum(i in FOODS)(cost[i] * x[i]);

% Objective
solve minimize total_cost;