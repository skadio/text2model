% Parameters
int: N = 7;
set of int: FOODS = 1..N;

array[FOODS] of int: protein = [18, 12, 7, 17, 3, 4, 4];
array[FOODS] of int: carbs   = [23, 30, 16, 26, 30, 6, 23];
array[FOODS] of int: calories= [217, 182, 79, 295, 264, 160, 141];
array[FOODS] of int: cost    = [3, 10, 10, 7, 4, 6, 5];

int: req_protein  = 59;
int: req_carbs    = 160;
int: req_calories = 1809;

% Safe upper bounds for servings (non-negative integers)
int: max_servings = max(
  max( ceil(req_protein / min(protein)), ceil(req_carbs / min(carbs)) ),
  ceil(req_calories / min(calories))
);

% Variables
array[FOODS] of var 0..max_servings: x; % number of servings of each food

var 0..(max_servings * sum(cost)): total_cost;

% Constraints
constraint total_cost = sum(i in FOODS)(cost[i] * x[i]);

constraint sum(i in FOODS)(protein[i]  * x[i]) >= req_protein;
constraint sum(i in FOODS)(carbs[i]    * x[i]) >= req_carbs;
constraint sum(i in FOODS)(calories[i] * x[i]) >= req_calories;

% Objective
solve minimize total_cost;