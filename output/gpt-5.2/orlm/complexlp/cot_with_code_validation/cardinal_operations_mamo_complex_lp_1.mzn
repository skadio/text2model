% Parameters
int: N = 4;
set of int: FOODS = 1..N;

array[FOODS] of int: protein = [19, 4, 3, 8];
array[FOODS] of int: carbs   = [9, 16, 11, 7];
array[FOODS] of int: calories= [83, 166, 71, 56];
array[FOODS] of int: cost    = [7, 7, 10, 2];

int: req_protein  = 84;
int: req_carbs    = 132;
int: req_calories = 1990;

% Variables
array[FOODS] of var 0..1000: x; % units to buy of each food item
var 0..100000: total_cost;

% Constraints
constraint total_cost = sum(i in FOODS)(cost[i] * x[i]);

constraint sum(i in FOODS)(protein[i]  * x[i]) >= req_protein;
constraint sum(i in FOODS)(carbs[i]    * x[i]) >= req_carbs;
constraint sum(i in FOODS)(calories[i] * x[i]) >= req_calories;

% Objective
solve minimize total_cost;