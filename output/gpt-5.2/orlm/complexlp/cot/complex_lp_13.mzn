% Parameters (with values embedded)
int: nFoods = 5;
set of int: FOODS = 1..nFoods;

array[FOODS] of string: foodName = ["Chicken","Rice","Broccoli","Tofu","Beans"];

array[FOODS] of int: protein = [18, 12, 13, 5, 10];
array[FOODS] of int: carbs   = [6,  28, 19, 16, 20];
array[FOODS] of int: calories= [142, 88, 137, 141, 150];
array[FOODS] of int: cost    = [4,  8,  7,  10, 1];

int: minProtein = 56;
int: minCarbs = 194;
int: minCalories = 2012;

% Variables
% servings[i] = number of servings of food i (nonnegative integer)
array[FOODS] of var 0..1000: servings;

var int: totalCost;
var int: totalProtein;
var int: totalCarbs;
var int: totalCalories;

% Constraints
constraint totalCost = sum(i in FOODS)(cost[i] * servings[i]);
constraint totalProtein = sum(i in FOODS)(protein[i] * servings[i]);
constraint totalCarbs = sum(i in FOODS)(carbs[i] * servings[i]);
constraint totalCalories = sum(i in FOODS)(calories[i] * servings[i]);

constraint totalProtein >= minProtein;
constraint totalCarbs >= minCarbs;
constraint totalCalories >= minCalories;

% Objective
solve minimize totalCost;