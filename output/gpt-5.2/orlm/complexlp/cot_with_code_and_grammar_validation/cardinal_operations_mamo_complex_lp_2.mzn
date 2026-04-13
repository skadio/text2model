% Parameters
int: N = 5;
set of int: FOODS = 1..N;

array[FOODS] of int: protein = [3, 17, 16, 8, 6];
array[FOODS] of int: carbs   = [16, 24, 27, 16, 6];
array[FOODS] of int: calories= [96, 182, 114, 208, 236];
array[FOODS] of int: cost    = [9, 9, 2, 9, 5];

int: req_protein = 100;
int: req_carbs   = 180;
int: req_calories= 1796;

% Safe upper bounds: worst-case by taking only the best item for each requirement
int: ub_protein  = (req_protein  + min(protein)  - 1) div min(protein);
int: ub_carbs    = (req_carbs    + min(carbs)    - 1) div min(carbs);
int: ub_calories = (req_calories + min(calories) - 1) div min(calories);
int: UB = max(ub_protein, max(ub_carbs, ub_calories));

% Variables
array[FOODS] of var 0..UB: x;

% Constraints
constraint sum(i in FOODS)(protein[i]  * x[i]) >= req_protein;
constraint sum(i in FOODS)(carbs[i]    * x[i]) >= req_carbs;
constraint sum(i in FOODS)(calories[i] * x[i]) >= req_calories;

% Objective
solve minimize sum(i in FOODS)(cost[i] * x[i]);