% Parameters (with values embedded)
int: nFoods = 4;
set of int: FOODS = 1..nFoods;

% Food indices: 1=Bread, 2=Milk, 3=Fish, 4=Potato
array[FOODS] of int: protein = [4, 6, 20, 1];
array[FOODS] of int: carbs   = [7, 10, 0, 30];
array[FOODS] of int: calories= [130, 120, 150, 70];
array[FOODS] of int: cost    = [3, 4, 8, 2];

int: minProtein  = 30;
int: minCarbs    = 40;
int: minCalories = 400;

% Variables
% x[i] = number of servings of food i (nonnegative integer)
array[FOODS] of var 0..100: x;

var int: total_cost;

% Constraints
constraint sum(i in FOODS)(protein[i] * x[i]) >= minProtein;
constraint sum(i in FOODS)(carbs[i]   * x[i]) >= minCarbs;
constraint sum(i in FOODS)(calories[i]* x[i]) >= minCalories;

constraint total_cost = sum(i in FOODS)(cost[i] * x[i]);

% Objective
solve minimize total_cost;