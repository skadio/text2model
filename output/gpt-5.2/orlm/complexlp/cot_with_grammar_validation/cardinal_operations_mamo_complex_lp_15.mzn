% Parameters
int: N = 6;
set of int: FOODS = 1..N;

array[FOODS] of int: protein = [1, 4, 13, 8, 7, 8];
array[FOODS] of int: carbs   = [13, 10, 9, 3, 13, 16];
array[FOODS] of int: calories= [211, 256, 273, 54, 93, 52];
array[FOODS] of int: cost    = [10, 9, 2, 10, 8, 1];

int: min_protein  = 60;
int: min_carbs    = 122;
int: min_calories = 2028;

% Variables
array[FOODS] of var 0..10000: x; % servings/units of each food
var 0..1000000: total_cost;

% Constraints
constraint total_cost = sum(i in FOODS)(cost[i] * x[i]);

constraint sum(i in FOODS)(protein[i] * x[i])  >= min_protein;
constraint sum(i in FOODS)(carbs[i]   * x[i])  >= min_carbs;
constraint sum(i in FOODS)(calories[i]* x[i])  >= min_calories;

% Objective
solve minimize total_cost;