% Parameters
int: N = 6;
set of int: FOODS = 1..N;

array[FOODS] of int: protein = [14, 2, 17, 3, 15, 2];
array[FOODS] of int: carbs   = [23, 13, 13, 1, 23, 8];
array[FOODS] of int: calories= [63, 162, 260, 55, 231, 297];
array[FOODS] of int: cost    = [4, 6, 6, 8, 8, 5];

int: minProtein  = 83;
int: minCarbs    = 192;
int: minCalories = 2089;

% Variables
int: maxProteinPerItem = max(protein);
int: maxCarbsPerItem   = max(carbs);
int: maxCaloriesPerItem= max(calories);

int: ubP = (minProtein + maxProteinPerItem - 1) div maxProteinPerItem;
int: ubC = (minCarbs + maxCarbsPerItem - 1) div maxCarbsPerItem;
int: ubK = (minCalories + maxCaloriesPerItem - 1) div maxCaloriesPerItem;
int: UB  = max(ubP, max(ubC, ubK));

array[FOODS] of var 0..UB: x;

var int: totalCost = sum(i in FOODS)(cost[i] * x[i]);

% Constraints
constraint sum(i in FOODS)(protein[i] * x[i]) >= minProtein;
constraint sum(i in FOODS)(carbs[i] * x[i]) >= minCarbs;
constraint sum(i in FOODS)(calories[i] * x[i]) >= minCalories;

% Objective
solve minimize totalCost;