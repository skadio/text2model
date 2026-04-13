% Parameters (with values embedded)
int: N = 6;
set of int: FOODS = 1..N;

% Food order: 1=Chicken, 2=Rice, 3=Vegetables, 4=Bread, 5=Almonds, 6=Salmon
array[FOODS] of int: protein = [16, 11, 1, 6, 2, 19];
array[FOODS] of int: carbs   = [8, 24, 5, 26, 11, 20];
array[FOODS] of int: calories= [50, 90, 164, 165, 51, 238];
array[FOODS] of int: cost    = [2, 3, 3, 2, 4, 10];

int: req_protein  = 58;
int: req_carbs    = 150;
int: req_calories = 2392;

% Safe upper bound: if we used only the best calories-per-item (Salmon=238),
% need at most ceil(2392/238)=11 items; use a slightly looser bound.
int: MAX_UNITS = 50;

% Variables
array[FOODS] of var 0..MAX_UNITS: x;  % number of units of each food
var 0..(MAX_UNITS * max(cost)): total_cost;

% Constraints
constraint total_cost = sum(i in FOODS)(cost[i] * x[i]);

constraint sum(i in FOODS)(protein[i]  * x[i]) >= req_protein;
constraint sum(i in FOODS)(carbs[i]    * x[i]) >= req_carbs;
constraint sum(i in FOODS)(calories[i] * x[i]) >= req_calories;

% Objective
solve minimize total_cost;