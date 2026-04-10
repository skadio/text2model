% Parameters
int: N = 6;
set of int: FOODS = 1..N;

array[FOODS] of int: protein = [18, 14, 18, 7, 15, 8];
array[FOODS] of int: carbs   = [5, 13, 4, 15, 17, 13];
array[FOODS] of int: calories= [202, 234, 220, 247, 88, 77];
array[FOODS] of int: cost    = [1, 7, 4, 3, 1, 2];

int: req_protein = 70;
int: req_carbs   = 187;
int: req_calories= 2181;

% Variables
array[FOODS] of var 0..req_calories: x; % servings/units of each food (nonnegative integers)
var 0..(req_calories * max(cost)): total_cost;

% Constraints
constraint forall(i in FOODS) (x[i] >= 0);

constraint sum(i in FOODS)(protein[i] * x[i]) >= req_protein;
constraint sum(i in FOODS)(carbs[i]   * x[i]) >= req_carbs;
constraint sum(i in FOODS)(calories[i]* x[i]) >= req_calories;

constraint total_cost = sum(i in FOODS)(cost[i] * x[i]);

% Objective
solve minimize total_cost;