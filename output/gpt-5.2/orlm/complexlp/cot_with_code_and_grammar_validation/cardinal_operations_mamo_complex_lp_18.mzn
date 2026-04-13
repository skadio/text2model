% Parameters
int: nFoods = 5;
set of int: FOODS = 1..nFoods;

array[FOODS] of int: protein = [1, 7, 6, 20, 8];
array[FOODS] of int: carbs   = [3, 22, 18, 6, 4];
array[FOODS] of int: cal     = [210, 96, 189, 132, 75];
array[FOODS] of int: cost    = [6, 1, 1, 3, 1];

int: minProtein = 87;
int: minCarbs   = 135;
int: minCal     = 1926;

% Variables
array[FOODS] of var 0..10000: x; % number of servings of each food item
var 0..1000000: totalCost;

% Constraints
constraint totalCost = sum(i in FOODS)(cost[i] * x[i]);

constraint sum(i in FOODS)(protein[i] * x[i]) >= minProtein;
constraint sum(i in FOODS)(carbs[i]   * x[i]) >= minCarbs;
constraint sum(i in FOODS)(cal[i]     * x[i]) >= minCal;

% Objective
solve minimize totalCost;