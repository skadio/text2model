% Parameters
int: nFoods = 4;
set of int: FOODS = 1..nFoods;

% Food order: 1=Chicken, 2=Rice, 3=Broccoli, 4=Eggs
array[FOODS] of int: protein = [17, 20, 3, 18];
array[FOODS] of int: carbs   = [6, 13, 25, 20];
array[FOODS] of int: calories= [94, 74, 73, 119];
array[FOODS] of int: cost    = [7, 10, 9, 2];

int: req_protein = 84;
int: req_carbs   = 117;
int: req_calories= 1554;

int: max_units = req_calories div min(calories) + 1;

% Variables
array[FOODS] of var 0..max_units: x;
var 0..(max_units * max(cost)): total_cost;

% Constraints
constraint total_cost = sum(i in FOODS)(cost[i] * x[i]);

constraint sum(i in FOODS)(protein[i] * x[i]) >= req_protein;
constraint sum(i in FOODS)(carbs[i]   * x[i]) >= req_carbs;
constraint sum(i in FOODS)(calories[i]* x[i]) >= req_calories;

% Objective
solve minimize total_cost;