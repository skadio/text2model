% Parameters
int: N = 5;
set of int: FOODS = 1..N;

array[FOODS] of int: protein = [3, 17, 16, 8, 6];
array[FOODS] of int: carbs   = [16, 24, 27, 16, 6];
array[FOODS] of int: calories= [96, 182, 114, 208, 236];
array[FOODS] of int: cost    = [9, 9, 2, 9, 5];

int: min_protein  = 100;
int: min_carbs    = 180;
int: min_calories = 1796;

int: max_units = max(
  max(ceil(min_protein / min(protein)), ceil(min_carbs / min(carbs))),
  ceil(min_calories / min(calories))
);

% Variables
array[FOODS] of var 0..max_units: x;
var 0..(max_units * max(cost)): total_cost;

% Constraints
constraint total_cost = sum(i in FOODS)(cost[i] * x[i]);

constraint sum(i in FOODS)(protein[i] * x[i])  >= min_protein;
constraint sum(i in FOODS)(carbs[i] * x[i])    >= min_carbs;
constraint sum(i in FOODS)(calories[i] * x[i]) >= min_calories;

% Objective
solve minimize total_cost;