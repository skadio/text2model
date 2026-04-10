% Parameters
int: N = 8;
set of int: FOODS = 1..N;

array[FOODS] of int: protein = [5, 8, 18, 16, 3, 3, 6, 17];
array[FOODS] of int: carbs   = [15, 17, 20, 15, 28, 19, 24, 9];
array[FOODS] of int: calories= [162, 282, 234, 85, 194, 153, 167, 192];
array[FOODS] of int: cost    = [8, 4, 1, 4, 7, 2, 9, 3];

int: min_protein  = 68;
int: min_carbs    = 189;
int: min_calories = 1840;

% Variables
array[FOODS] of var 0..100: x; % number of units of each food item chosen

var 0..100000: total_cost;

% Constraints
constraint total_cost = sum(i in FOODS)(cost[i] * x[i]);

constraint sum(i in FOODS)(protein[i]  * x[i]) >= min_protein;
constraint sum(i in FOODS)(carbs[i]    * x[i]) >= min_carbs;
constraint sum(i in FOODS)(calories[i] * x[i]) >= min_calories;

% Objective
solve minimize total_cost;