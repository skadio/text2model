% Parameters
int: nFoods = 5;
set of int: FOODS = 1..nFoods;

array[FOODS] of int: protein = [8, 10, 3, 16, 4];
array[FOODS] of int: carbs   = [8, 30, 10, 29, 24];
array[FOODS] of int: calories= [118, 131, 151, 235, 101];
array[FOODS] of int: cost    = [6, 10, 1, 9, 4];

int: minProtein  = 93;
int: minCarbs    = 181;
int: minCalories = 1620;

% Variables
array[FOODS] of var 0..ceil(int2float(max([minProtein, minCarbs, minCalories]))): x;
var int: totalCost;

% Constraints
constraint sum(i in FOODS)(protein[i] * x[i]) >= minProtein;
constraint sum(i in FOODS)(carbs[i]   * x[i]) >= minCarbs;
constraint sum(i in FOODS)(calories[i]* x[i]) >= minCalories;

constraint totalCost = sum(i in FOODS)(cost[i] * x[i]);

% Objective
solve minimize totalCost;

output [show(totalCost)];