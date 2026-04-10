% Parameters (with values embedded)
int: nFoods = 4;
set of int: FOODS = 1..nFoods;

% 1=Bread, 2=Milk, 3=Fish, 4=Potato
array[FOODS] of int: protein = [4, 6, 20, 1];
array[FOODS] of int: carbs   = [7, 10, 0, 30];
array[FOODS] of int: calories= [130, 120, 150, 70];
array[FOODS] of int: cost    = [3, 4, 8, 2];

int: minProtein  = 40;
int: minCarbs    = 50;
int: minCalories = 450;

% Variables
array[FOODS] of var 0..1000: x; % number of servings of each food (integer servings)

var 0..100000: totalCost;

% Constraints
constraint sum(f in FOODS)(protein[f] * x[f]) >= minProtein;
constraint sum(f in FOODS)(carbs[f]   * x[f]) >= minCarbs;
constraint sum(f in FOODS)(calories[f]* x[f]) >= minCalories;

constraint totalCost = sum(f in FOODS)(cost[f] * x[f]);

% Objective
solve minimize totalCost;