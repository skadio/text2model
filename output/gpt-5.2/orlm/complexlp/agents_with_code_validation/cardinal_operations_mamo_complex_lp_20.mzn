% Parameters
int: nFoods = 4;
set of int: FOODS = 1..nFoods;

% Food option names (for readability in output)
array[FOODS] of string: foodName = ["Chicken","Cheese","Rice","Beans"];

% Nutritional content per unit of each food
array[FOODS] of int: protein  = [16, 10, 12, 13];
array[FOODS] of int: carbs    = [22,  4, 21, 14];
array[FOODS] of int: calories = [292, 82, 207, 81];

% Cost per unit of each food
array[FOODS] of int: cost = [5, 9, 2, 1];

% Minimum required nutrients
int: minProtein  = 94;
int: minCarbs    = 191;
int: minCalories = 2271;

% Variables
% Number of units chosen of each food (nonnegative integer)
array[FOODS] of var 0..10000: x;

% Total cost (bounded above by a safe upper bound)
var 0..10000: totalCost;

% Constraints
% Link total cost to decision variables
constraint totalCost = sum(i in FOODS) (cost[i] * x[i]);

% --- Nutrient minimum requirements ---
constraint sum(i in FOODS) (protein[i]  * x[i]) >= minProtein;
constraint sum(i in FOODS) (carbs[i]    * x[i]) >= minCarbs;
constraint sum(i in FOODS) (calories[i] * x[i]) >= minCalories;

% Objective
solve minimize totalCost;