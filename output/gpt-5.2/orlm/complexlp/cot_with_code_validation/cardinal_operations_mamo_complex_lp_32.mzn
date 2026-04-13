% Parameters
int: N = 6;
set of int: FOODS = 1..N;

array[FOODS] of string: name = ["Pasta","Avocado","Chicken","Tofu","Spinach","Cheese"];

array[FOODS] of int: protein = [15,20,15,19,19,12];
array[FOODS] of int: carbs   = [30,16,8,5,28,17];
array[FOODS] of int: calories= [154,111,211,87,98,231];
array[FOODS] of int: cost    = [3,8,7,2,9,10];

int: minProtein  = 73;
int: minCarbs    = 111;
int: minCalories = 2196;

% Variables
array[FOODS] of var 0..1000: x; % servings of each food (integer)
var 0..1000000: totalCost;

% Constraints
constraint totalCost = sum(i in FOODS)(cost[i] * x[i]);

constraint sum(i in FOODS)(protein[i]  * x[i]) >= minProtein;
constraint sum(i in FOODS)(carbs[i]    * x[i]) >= minCarbs;
constraint sum(i in FOODS)(calories[i] * x[i]) >= minCalories;

% Objective
solve minimize totalCost;