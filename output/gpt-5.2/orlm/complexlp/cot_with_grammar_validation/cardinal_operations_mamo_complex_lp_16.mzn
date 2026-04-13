% Parameters
int: nFoods = 4;
set of int: FOODS = 1..nFoods;

array[FOODS] of int: protein = [10, 4, 13, 15];
array[FOODS] of int: carbs   = [17, 3, 8, 25];
array[FOODS] of int: calories= [159,126,230,112];
array[FOODS] of int: cost    = [5,  5,  8,  3];

int: minProtein  = 66;
int: minCarbs    = 101;
int: minCalories = 1701;

% Variables
array[FOODS] of var 0..100: x;

var 0..(100 * sum(cost)): totalCost;

% Constraints
constraint sum(i in FOODS)(protein[i] * x[i]) >= minProtein;
constraint sum(i in FOODS)(carbs[i]   * x[i]) >= minCarbs;
constraint sum(i in FOODS)(calories[i]* x[i]) >= minCalories;

constraint totalCost = sum(i in FOODS)(cost[i] * x[i]);

% Objective
solve minimize totalCost;