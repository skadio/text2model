% Parameters (with values embedded)
int: nFoods = 5;
set of int: FOODS = 1..nFoods;

array[FOODS] of string: foodName = ["Chicken","Rice","Apples","Cheese","Tofu"];

array[FOODS] of int: protein = [14, 10, 4, 19, 10];
array[FOODS] of int: carbs   = [28, 27,13,  5,  8];
array[FOODS] of int: calories= [184,298,162, 81,147];
array[FOODS] of int: cost    = [5,  1,  5,  9,  9];

int: minProtein = 97;
int: minCarbs   = 140;
int: minCalories= 2304;

% Variables
% x[i] = number of servings of food i
array[FOODS] of var 0..200: x;
var int: totalCost;

% Constraints
constraint sum(i in FOODS)(protein[i] * x[i]) >= minProtein;
constraint sum(i in FOODS)(carbs[i]   * x[i]) >= minCarbs;
constraint sum(i in FOODS)(calories[i]* x[i]) >= minCalories;

constraint totalCost = sum(i in FOODS)(cost[i] * x[i]);

% Objective
solve minimize totalCost;