% Parameters (with values embedded)
int: nFoods = 6;
set of int: FOODS = 1..nFoods;

array[FOODS] of string: foodName = ["Pasta","Avocado","Chicken","Tofu","Spinach","Cheese"];

array[FOODS] of int: protein = [15,20,15,19,19,12];
array[FOODS] of int: carbs   = [30,16, 8, 5,28,17];
array[FOODS] of int: calories= [154,111,211, 87,98,231];
array[FOODS] of int: cost    = [  3,  8,  7,  2, 9, 10];

int: minProtein = 73;
int: minCarbs   = 111;
int: minCalories= 2196;

% Variables
array[FOODS] of var 0..100: x; % number of units of each food (upper bound set conservatively)

var int: totalCost;

% Constraints
constraint sum(i in FOODS)(protein[i] * x[i]) >= minProtein;
constraint sum(i in FOODS)(carbs[i]   * x[i]) >= minCarbs;
constraint sum(i in FOODS)(calories[i]* x[i]) >= minCalories;

constraint totalCost = sum(i in FOODS)(cost[i] * x[i]);

% Objective
solve minimize totalCost;

output [show(totalCost)];