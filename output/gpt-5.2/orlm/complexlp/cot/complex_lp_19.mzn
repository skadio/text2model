% Parameters (with values embedded)
int: nFoods = 4;
set of int: FOODS = 1..nFoods;

array[FOODS] of string: foodName = ["Eggs","Rice","Chicken","Broccoli"];

array[FOODS] of int: cost = [6, 10, 1, 7];
array[FOODS] of int: protein = [4, 1, 10, 8];
array[FOODS] of int: carbs = [13, 13, 29, 26];
array[FOODS] of int: calories = [238, 85, 146, 139];

int: minProtein = 93;
int: minCarbs = 165;
int: minCalories = 1553;

% Variables
array[FOODS] of var 0..10000: qty; % number of servings/units of each food item
var 0..1000000: totalCost;

% Constraints
constraint totalCost = sum(f in FOODS)(cost[f] * qty[f]);

constraint sum(f in FOODS)(protein[f] * qty[f]) >= minProtein;
constraint sum(f in FOODS)(carbs[f] * qty[f]) >= minCarbs;
constraint sum(f in FOODS)(calories[f] * qty[f]) >= minCalories;

% Objective
solve minimize totalCost;