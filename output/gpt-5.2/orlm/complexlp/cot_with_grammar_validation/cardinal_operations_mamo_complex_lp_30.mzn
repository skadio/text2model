% Parameters
int: nFoods = 5;
set of int: FOODS = 1..nFoods;

array[FOODS] of int: protein = [8, 10, 3, 16, 4];
array[FOODS] of int: carbs   = [8, 30, 10, 29, 24];
array[FOODS] of int: calories= [118, 131, 151, 235, 101];
array[FOODS] of int: price   = [6, 10, 1, 9, 4];

int: minProtein = 93;
int: minCarbs   = 181;
int: minCalories= 1620;

int: maxCost = max(price) * max(minProtein div min(protein), max(minCarbs div min(carbs), minCalories div min(calories)) + 1);
int: maxQty  = max(minProtein div min(protein), max(minCarbs div min(carbs), minCalories div min(calories)) + 1);

% Variables
array[FOODS] of var 0..maxQty: x;
var 0..maxCost: totalCost;

% Constraints
constraint totalCost = sum(i in FOODS)(price[i] * x[i]);

constraint sum(i in FOODS)(protein[i]  * x[i]) >= minProtein;
constraint sum(i in FOODS)(carbs[i]    * x[i]) >= minCarbs;
constraint sum(i in FOODS)(calories[i] * x[i]) >= minCalories;

% Objective
solve minimize totalCost;