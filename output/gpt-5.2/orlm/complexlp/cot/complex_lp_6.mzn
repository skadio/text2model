% Parameters (with values embedded)
int: nFoods = 5;
set of int: FOODS = 1..nFoods;

array[FOODS] of int: protein = [10, 3, 17, 6, 20];
array[FOODS] of int: carbs   = [22, 4, 10, 13, 5];
array[FOODS] of int: calories= [80, 189, 153, 232, 204];
array[FOODS] of int: cost    = [2, 8, 4, 1, 8];

int: minProtein  = 74;
int: minCarbs    = 102;
int: minCalories = 1564;

% Variables
array[FOODS] of var 0..100: x; % quantity (non-negative integer units of each food)

var 0..100000: totalProtein;
var 0..100000: totalCarbs;
var 0..100000: totalCalories;
var 0..100000: totalCost;

% Constraints
constraint totalProtein  = sum(f in FOODS)(protein[f]  * x[f]);
constraint totalCarbs    = sum(f in FOODS)(carbs[f]    * x[f]);
constraint totalCalories = sum(f in FOODS)(calories[f] * x[f]);
constraint totalCost     = sum(f in FOODS)(cost[f]     * x[f]);

constraint totalProtein  >= minProtein;
constraint totalCarbs    >= minCarbs;
constraint totalCalories >= minCalories;

% Objective
solve minimize totalCost;