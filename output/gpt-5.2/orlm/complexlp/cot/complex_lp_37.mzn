% Parameters (with values embedded)
int: nFoods = 4;
set of int: FOODS = 1..nFoods;

array[FOODS] of int: cost = [4, 4, 2, 4];          % Chicken, Rice, Beans, Avocado
array[FOODS] of int: protein = [14, 5, 9, 10];
array[FOODS] of int: carbs   = [7, 13, 26, 14];
array[FOODS] of int: calories= [208, 140, 280, 199];

int: targetProtein = 74;
int: targetCarbs   = 166;
int: targetCalories= 2210;

% Variables
array[FOODS] of var 0..1000: x;   % servings/units of each food (nonnegative integers)
var 0..100000: totalCost;

% Constraints
constraint totalCost = sum(i in FOODS)(cost[i] * x[i]);

constraint sum(i in FOODS)(protein[i]  * x[i]) >= targetProtein;
constraint sum(i in FOODS)(carbs[i]    * x[i]) >= targetCarbs;
constraint sum(i in FOODS)(calories[i] * x[i]) >= targetCalories;

% Objective
solve minimize totalCost;

output [show(totalCost)];