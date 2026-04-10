% Parameters (with values embedded)
int: nFoods = 5;
set of int: FOODS = 1..nFoods;

array[FOODS] of string: foodName = ["Chicken","Rice","Beans","Broccoli","Fruit"];

array[FOODS] of int: protein = [12, 12, 19, 19, 4];
array[FOODS] of int: carbs   = [ 2, 24, 18,  7,27];
array[FOODS] of int: calories= [186,250,134, 84,104];
array[FOODS] of int: cost    = [ 6,  6,  6,  7,  9];

int: reqProtein  = 97;
int: reqCarbs    = 163;
int: reqCalories = 2217;

% Variables
array[FOODS] of var 0..200: x; % number of servings of each food (integer, nonnegative)

var 0..100000: totalCost;

% Constraints
constraint totalCost = sum(i in FOODS)(cost[i] * x[i]);

constraint sum(i in FOODS)(protein[i]  * x[i]) >= reqProtein;
constraint sum(i in FOODS)(carbs[i]    * x[i]) >= reqCarbs;
constraint sum(i in FOODS)(calories[i] * x[i]) >= reqCalories;

% Objective
solve minimize totalCost;