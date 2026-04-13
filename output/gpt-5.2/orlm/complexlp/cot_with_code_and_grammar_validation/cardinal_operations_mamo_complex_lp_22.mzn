% Parameters
int: N = 6;
set of int: FOODS = 1..N;

array[FOODS] of int: protein = [15, 16, 3, 19, 11, 10];
array[FOODS] of int: carbs   = [10, 25, 8, 20, 8, 9];
array[FOODS] of int: calories= [163,108,198,141,105,199];
array[FOODS] of int: cost    = [10, 4, 1, 7, 6, 8];

int: req_protein = 88;
int: req_carbs   = 144;
int: req_calories= 1900;

% Variables
array[FOODS] of var 0..100: x; % servings of each food item (bounded)

var int: total_cost;

% Constraints
constraint sum(i in FOODS)(protein[i] * x[i]) >= req_protein;
constraint sum(i in FOODS)(carbs[i]   * x[i]) >= req_carbs;
constraint sum(i in FOODS)(calories[i]* x[i]) >= req_calories;

constraint total_cost = sum(i in FOODS)(cost[i] * x[i]);

% Objective
solve minimize total_cost;