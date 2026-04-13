% Parameters
int: nFoods = 6;
set of int: FOODS = 1..nFoods;

array[FOODS] of int: cost = [6, 8, 4, 1, 3, 5];

array[FOODS] of int: protein = [20, 2, 10, 5, 17, 6];
array[FOODS] of int: carbs   = [9, 15, 30, 19, 12, 18];
array[FOODS] of int: cal     = [89, 276, 255, 258, 212, 246];

int: minProtein = 90;
int: minCarbs   = 162;
int: minCal     = 1926;

% Variables
array[FOODS] of var 0..50: x;  % number of servings of each food
var int: totalCost;

% Constraints
constraint totalCost = sum(i in FOODS)(cost[i] * x[i]);

constraint sum(i in FOODS)(protein[i] * x[i]) >= minProtein;
constraint sum(i in FOODS)(carbs[i]   * x[i]) >= minCarbs;
constraint sum(i in FOODS)(cal[i]     * x[i]) >= minCal;

% Objective
solve minimize totalCost;