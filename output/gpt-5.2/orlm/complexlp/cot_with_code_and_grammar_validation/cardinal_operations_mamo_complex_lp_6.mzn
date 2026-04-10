% Parameters
int: N = 5;
set of int: FOODS = 1..N;

array[FOODS] of int: protein = [10, 3, 17, 6, 20];
array[FOODS] of int: carbs   = [22, 4, 10, 13, 5];
array[FOODS] of int: calories= [80, 189, 153, 232, 204];
array[FOODS] of int: cost    = [2, 8, 4, 1, 8];

int: req_protein  = 74;
int: req_carbs    = 102;
int: req_calories = 1564;

int: minCost = min(cost);
int: maxReq = max([req_protein, req_carbs, req_calories]);
int: minNutr = min([min(protein), min(carbs), min(calories)]);
int: UB = maxReq div minNutr + 1; % safe upper bound on servings per food

% Variables
array[FOODS] of var 0..UB: x; % number of servings of each food (integer, nonnegative)

var 0..(UB * sum(cost)): total_cost;

% Constraints
constraint total_cost = sum(i in FOODS)(cost[i] * x[i]);

constraint sum(i in FOODS)(protein[i]  * x[i]) >= req_protein;
constraint sum(i in FOODS)(carbs[i]    * x[i]) >= req_carbs;
constraint sum(i in FOODS)(calories[i] * x[i]) >= req_calories;

% Objective
solve minimize total_cost;