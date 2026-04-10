% Parameters
int: nFoods = 4;
set of int: FOODS = 1..nFoods;

array[FOODS] of int: cost = [4, 4, 2, 4];
array[FOODS] of int: protein = [14, 5, 9, 10];
array[FOODS] of int: carbs = [7, 13, 26, 14];
array[FOODS] of int: calories = [208, 140, 280, 199];

int: reqProtein = 74;
int: reqCarbs = 166;
int: reqCalories = 2210;

int: maxUnits = max(reqProtein div min(protein), max(reqCarbs div min(carbs), reqCalories div min(calories))) + 20;

% Variables
array[FOODS] of var 0..maxUnits: x;
var 0..(maxUnits * sum(cost)): totalCost;

% Constraints
constraint totalCost = sum(f in FOODS)(cost[f] * x[f]);

constraint sum(f in FOODS)(protein[f] * x[f]) >= reqProtein;
constraint sum(f in FOODS)(carbs[f] * x[f]) >= reqCarbs;
constraint sum(f in FOODS)(calories[f] * x[f]) >= reqCalories;

% Objective
solve minimize totalCost;