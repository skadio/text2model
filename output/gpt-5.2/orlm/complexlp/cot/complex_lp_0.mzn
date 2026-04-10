% Parameters (with values embedded)
int: n = 6;
set of int: FOODS = 1..n;

array[FOODS] of string: food_name = ["Steak","Tofu","Chicken","Broccoli","Rice","Spinach"];

array[FOODS] of int: protein = [14, 2, 17, 3, 15, 2];
array[FOODS] of int: carbs   = [23,13, 13, 1, 23, 8];
array[FOODS] of int: calories= [63,162,260,55,231,297];
array[FOODS] of int: cost    = [ 4,  6,  6, 8,  8,  5];

int: req_protein  = 83;
int: req_carbs    = 192;
int: req_calories = 2089;

% Variables
% servings[i] = number of servings of food i (nonnegative integer)
array[FOODS] of var 0..1000: servings;

var 0..100000: total_cost;

% Constraints
constraint total_cost = sum(i in FOODS)(cost[i] * servings[i]);

constraint sum(i in FOODS)(protein[i]  * servings[i]) >= req_protein;
constraint sum(i in FOODS)(carbs[i]    * servings[i]) >= req_carbs;
constraint sum(i in FOODS)(calories[i] * servings[i]) >= req_calories;

% Objective
solve minimize total_cost;