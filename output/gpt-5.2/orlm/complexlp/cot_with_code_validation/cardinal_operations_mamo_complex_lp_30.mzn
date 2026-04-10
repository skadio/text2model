% Parameters
int: N = 5;
set of int: FOODS = 1..N;

array[FOODS] of int: protein = [8, 10, 3, 16, 4];
array[FOODS] of int: carbs   = [8, 30, 10, 29, 24];
array[FOODS] of int: calories= [118, 131, 151, 235, 101];
array[FOODS] of int: price   = [6, 10, 1, 9, 4];

int: req_protein  = 93;
int: req_carbs    = 181;
int: req_calories = 1620;

% Variables
array[FOODS] of var 0..1000: x;
var 0..100000: total_cost = sum(i in FOODS)(price[i] * x[i]);

% Constraints
constraint sum(i in FOODS)(protein[i] * x[i])  >= req_protein;
constraint sum(i in FOODS)(carbs[i] * x[i])    >= req_carbs;
constraint sum(i in FOODS)(calories[i] * x[i]) >= req_calories;

% Objective
solve minimize total_cost;

output [show(total_cost)];