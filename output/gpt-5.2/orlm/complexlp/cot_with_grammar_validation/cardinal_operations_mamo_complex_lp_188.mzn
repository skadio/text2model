% Parameters
int: nFoods = 4;
set of int: FOODS = 1..nFoods;

array[FOODS] of int: protein = [4, 6, 20, 1];
array[FOODS] of int: carbs   = [7, 10, 0, 30];
array[FOODS] of int: calories= [130, 120, 150, 70];
array[FOODS] of int: cost    = [3, 4, 8, 2];

int: reqProtein  = 40;
int: reqCarbs    = 50;
int: reqCalories = 450;

% Upper bounds based on meeting calories alone with the lowest-calorie food (70):
int: maxUnits = (reqCalories div 70) + 10;

% Variables
array[FOODS] of var 0..maxUnits: x;           % number of units of each food
var 0..(maxUnits * sum(i in FOODS)(cost[i])): totalCost;

% Constraints
constraint totalCost = sum(i in FOODS)(cost[i] * x[i]);

constraint sum(i in FOODS)(protein[i]  * x[i]) >= reqProtein;
constraint sum(i in FOODS)(carbs[i]    * x[i]) >= reqCarbs;
constraint sum(i in FOODS)(calories[i] * x[i]) >= reqCalories;

% Objective
solve minimize totalCost;