% Parameters
int: nFoods = 8;
set of int: FOODS = 1..nFoods;

array[FOODS] of int: protein = [1, 18, 19, 19, 3, 8, 15, 3];
array[FOODS] of int: carbs   = [4,  2,  26, 10, 24, 26, 27, 30];
array[FOODS] of int: calories= [93, 219, 155, 105, 255, 182, 173, 191];
array[FOODS] of int: cost    = [6,  4,  4,  3,  2,  7,  3,  3];

int: reqProtein = 98;
int: reqCarbs   = 113;
int: reqCalories= 1768;

int: maxItems = 1000;

% Variables
array[FOODS] of var 0..maxItems: x;
var 0..(maxItems * sum(cost)): total_cost;

% Constraints
constraint total_cost = sum(i in FOODS)(cost[i] * x[i]);

constraint sum(i in FOODS)(protein[i] * x[i]) >= reqProtein;
constraint sum(i in FOODS)(carbs[i]   * x[i]) >= reqCarbs;
constraint sum(i in FOODS)(calories[i]* x[i]) >= reqCalories;

% Objective
solve minimize total_cost;