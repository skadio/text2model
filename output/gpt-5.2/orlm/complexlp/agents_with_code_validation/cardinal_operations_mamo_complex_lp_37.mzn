% Parameters
int: nFoods = 4;
set of int: FOODS = 1..nFoods;

% Food indices (for readability)
int: CHICKEN = 1;
int: RICE    = 2;
int: BEANS   = 3;
int: AVOCADO = 4;

% Nutrition targets (daily requirements)
int: targetProtein  = 74;
int: targetCarbs    = 166;
int: targetCalories = 2210;

% Cost per unit of each food
array[FOODS] of int: cost = [4, 4, 2, 4];

% Nutrition per unit of each food
array[FOODS] of int: protein  = [14, 5,  9, 10];
array[FOODS] of int: carbs    = [ 7, 13, 26, 14];
array[FOODS] of int: calories = [208,140,280,199];

% Variables
% Number of units chosen for each food (nonnegative integers)
array[FOODS] of var 0..1000: x;

% Total cost (bounded above by max cost * max units)
var 0..(1000 * max(cost)): totalCost;

% Constraints
% Total cost definition
constraint totalCost = sum(f in FOODS)(cost[f] * x[f]);

% Meet or exceed nutrition requirements
constraint sum(f in FOODS)(protein[f]  * x[f]) >= targetProtein;
constraint sum(f in FOODS)(carbs[f]    * x[f]) >= targetCarbs;
constraint sum(f in FOODS)(calories[f] * x[f]) >= targetCalories;

% Objective
solve minimize totalCost;

output [show(totalCost)];