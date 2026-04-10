% Parameters
% Number of food items
int: nFoods = 5;

% Index set for foods
set of int: FOODS = 1..nFoods;

% Food names (for readability/output)
array[FOODS] of string: foodName = ["Chicken", "Pasta", "Rice", "Beans", "Cheese"];

% Cost per unit of each food
array[FOODS] of int: cost = [7, 10, 7, 9, 7];

% Nutrients per unit of each food
array[FOODS] of int: protein  = [5, 3, 11, 10, 4];
array[FOODS] of int: carbs    = [13, 23, 27, 27, 18];
array[FOODS] of int: calories = [121, 274, 251, 259, 199];

% Minimum daily requirements
int: minProtein  = 60;
int: minCarbs    = 146;
int: minCalories = 1727;

% Variables
% Units of each food chosen (non-negative integers)
array[FOODS] of var 0..1000: qty;

% Total nutrients and total cost (bounded for linear expressions)
var 0..1000000: totalCost;
var 0..1000000: totalProtein;
var 0..1000000: totalCarbs;
var 0..1000000: totalCalories;

% Constraints
% Compute totals from selected quantities
constraint totalCost     = sum(f in FOODS)(cost[f]     * qty[f]);
constraint totalProtein  = sum(f in FOODS)(protein[f]  * qty[f]);
constraint totalCarbs    = sum(f in FOODS)(carbs[f]    * qty[f]);
constraint totalCalories = sum(f in FOODS)(calories[f] * qty[f]);

% Enforce minimum daily requirements
constraint totalProtein  >= minProtein;
constraint totalCarbs    >= minCarbs;
constraint totalCalories >= minCalories;

% Objective
solve minimize totalCost;