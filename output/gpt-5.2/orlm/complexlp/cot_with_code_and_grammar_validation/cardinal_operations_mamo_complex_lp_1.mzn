% Parameters
int: nFoods = 4;
set of int: FOODS = 1..nFoods;

array[FOODS] of int: protein = [19, 4, 3, 8];
array[FOODS] of int: carbs   = [9, 16, 11, 7];
array[FOODS] of int: calories= [83, 166, 71, 56];
array[FOODS] of int: cost    = [7, 7, 10, 2];

int: reqProtein  = 84;
int: reqCarbs    = 132;
int: reqCalories = 1990;

% Variables
% Upper bound: buying more than needed for calories with the smallest-calorie food (Food_4) is never beneficial.
int: maxUnits = (reqCalories div min(calories)) + 1;
array[FOODS] of var 0..maxUnits: x;

var 0..(maxUnits * sum(cost)): totalCost;

% Constraints
constraint totalCost = sum(f in FOODS)(cost[f] * x[f]);

constraint sum(f in FOODS)(protein[f]  * x[f]) >= reqProtein;
constraint sum(f in FOODS)(carbs[f]    * x[f]) >= reqCarbs;
constraint sum(f in FOODS)(calories[f] * x[f]) >= reqCalories;

% Objective
solve minimize totalCost;