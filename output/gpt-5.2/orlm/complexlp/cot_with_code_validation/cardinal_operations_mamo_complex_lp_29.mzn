% Parameters
int: N = 4;
set of int: FOODS = 1..N;

array[FOODS] of int: cost = [3, 6, 1, 10];
array[FOODS] of int: protein = [2, 18, 2, 18];
array[FOODS] of int: carbs = [4, 17, 28, 27];
array[FOODS] of int: calories = [218, 290, 298, 158];

int: min_protein = 86;
int: min_carbs = 120;
int: min_calories = 2435;

% Variables
int: max_units = max(
  ceil(min_protein / min(protein)),
  max(ceil(min_carbs / min(carbs)), ceil(min_calories / min(calories)))
);

array[FOODS] of var 0..max_units: x;

var 0..(max_units * sum(cost)): total_cost =
  sum(i in FOODS)(cost[i] * x[i]);

% Constraints
constraint sum(i in FOODS)(protein[i] * x[i]) >= min_protein;
constraint sum(i in FOODS)(carbs[i] * x[i]) >= min_carbs;
constraint sum(i in FOODS)(calories[i] * x[i]) >= min_calories;

% Objective
solve minimize total_cost;