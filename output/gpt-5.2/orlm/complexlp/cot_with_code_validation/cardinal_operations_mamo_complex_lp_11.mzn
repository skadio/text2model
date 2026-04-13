% Parameters
int: N = 5;
set of int: FOODS = 1..N;

array[FOODS] of int: cost = [7, 10, 7, 9, 7];
array[FOODS] of int: protein = [5, 3, 11, 10, 4];
array[FOODS] of int: carbs = [13, 23, 27, 27, 18];
array[FOODS] of int: calories = [121, 274, 251, 259, 199];

int: req_protein = 60;
int: req_carbs = 146;
int: req_calories = 1727;

int: max_cost_per_item = max(cost);
int: max_qty = (max([req_protein div min(protein),
                     req_carbs div min(carbs),
                     req_calories div min(calories)]) + 10);

% Variables
array[FOODS] of var 0..max_qty: x;
var 0..(max_qty * sum(cost)): total_cost;

% Constraints
constraint total_cost = sum(i in FOODS)(cost[i] * x[i]);

constraint sum(i in FOODS)(protein[i] * x[i]) >= req_protein;
constraint sum(i in FOODS)(carbs[i] * x[i]) >= req_carbs;
constraint sum(i in FOODS)(calories[i] * x[i]) >= req_calories;

% Objective
solve minimize total_cost;