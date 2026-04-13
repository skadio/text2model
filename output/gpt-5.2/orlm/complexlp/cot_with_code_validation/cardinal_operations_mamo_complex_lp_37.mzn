% Parameters
int: N = 4;
set of int: FOODS = 1..N;

array[FOODS] of int: cost = [4, 4, 2, 4];
array[FOODS] of int: protein = [14, 5, 9, 10];
array[FOODS] of int: carbs = [7, 13, 26, 14];
array[FOODS] of int: calories = [208, 140, 280, 199];

int: protein_req = 74;
int: carbs_req = 166;
int: calories_req = 2210;

% Variables
array[FOODS] of var 0..2210: x;

var 0..(2210 * 4): total_cost;

% Constraints
constraint total_cost = sum(i in FOODS)(cost[i] * x[i]);

constraint sum(i in FOODS)(protein[i] * x[i]) >= protein_req;
constraint sum(i in FOODS)(carbs[i] * x[i]) >= carbs_req;
constraint sum(i in FOODS)(calories[i] * x[i]) >= calories_req;

% Objective
solve minimize total_cost;