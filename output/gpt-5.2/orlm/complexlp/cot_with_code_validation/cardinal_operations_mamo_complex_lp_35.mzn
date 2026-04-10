% Parameters
int: nFoods = 7;
set of int: FOODS = 1..nFoods;

array[FOODS] of int: cost = [6, 2, 10, 6, 4, 1, 9];
array[FOODS] of int: protein = [6, 16, 12, 9, 12, 12, 13];
array[FOODS] of int: carbs = [3, 3, 17, 28, 17, 14, 20];
array[FOODS] of int: calories = [73, 181, 231, 160, 209, 184, 118];

int: minProtein = 59;
int: minCarbs = 179;
int: minCalories = 2414;

int: maxCost = max(cost);
int: maxProtein = max(protein);
int: maxCarbs = max(carbs);
int: maxCalories = max(calories);

int: ubByProtein = (minProtein + maxProtein - 1) div maxProtein;
int: ubByCarbs = (minCarbs + maxCarbs - 1) div maxCarbs;
int: ubByCalories = (minCalories + maxCalories - 1) div maxCalories;
int: ub = max(ubByProtein, max(ubByCarbs, ubByCalories));

% Variables
array[FOODS] of var 0..ub: x;
var 0..(ub * nFoods * maxCost): totalCost;

% Constraints
constraint totalCost = sum(i in FOODS)(cost[i] * x[i]);

constraint sum(i in FOODS)(protein[i] * x[i]) >= minProtein;
constraint sum(i in FOODS)(carbs[i] * x[i]) >= minCarbs;
constraint sum(i in FOODS)(calories[i] * x[i]) >= minCalories;

% Objective
solve minimize totalCost;