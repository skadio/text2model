% Parameters
int: N = 9;
set of int: FOODS = 1..N;

array[FOODS] of int: protein = [15, 1, 1, 6, 3, 17, 18, 12, 2];
array[FOODS] of int: carbs   = [18, 25, 21, 3, 7, 13, 27, 17, 30];
array[FOODS] of int: calories= [300, 267, 266, 119, 166, 129, 216, 76, 258];
array[FOODS] of int: cost    = [4, 2, 5, 10, 2, 8, 10, 9, 4];

int: min_protein  = 90;
int: min_carbs    = 105;
int: min_calories = 1805;

int: max_units = max([
  (min_protein  + min(protein)  - 1) div min(protein),
  (min_carbs    + min(carbs)    - 1) div min(carbs),
  (min_calories + min(calories) - 1) div min(calories)
]);

% Variables
array[FOODS] of var 0..max_units: x;
var 0..(max_units * sum(cost)): total_cost;

% Constraints
constraint total_cost = sum(i in FOODS)(cost[i] * x[i]);

constraint sum(i in FOODS)(protein[i] * x[i])  >= min_protein;
constraint sum(i in FOODS)(carbs[i]   * x[i])  >= min_carbs;
constraint sum(i in FOODS)(calories[i]* x[i])  >= min_calories;

% Objective
solve minimize total_cost;