% Parameters (with values embedded)
int: nFoods = 4;
set of int: FOODS = 1..nFoods;

array[FOODS] of int: protein = [19, 4, 3, 8];
array[FOODS] of int: carbs   = [ 9,16,11, 7];
array[FOODS] of int: calories= [83,166,71,56];
array[FOODS] of int: cost    = [ 7, 7,10, 2];

int: reqProtein  = 84;
int: reqCarbs    = 132;
int: reqCalories = 1990;

% Variables
array[FOODS] of var 0..1000: x; % number of units purchased of each food
var 0..100000: totalCost;

% Constraints
constraint sum(f in FOODS)(protein[f] * x[f]) >= reqProtein;
constraint sum(f in FOODS)(carbs[f]   * x[f]) >= reqCarbs;
constraint sum(f in FOODS)(calories[f]* x[f]) >= reqCalories;

constraint totalCost = sum(f in FOODS)(cost[f] * x[f]);

% Objective
solve minimize totalCost;