% Parameters
% Number of food items
int: n_foods = 4;

% Index set of foods
set of int: FOODS = 1..n_foods;

% Nutrition per unit of each food (grams / calories)
array[FOODS] of int: protein  = [17, 20,  3, 18];
array[FOODS] of int: carbs    = [ 6, 13, 25, 20];
array[FOODS] of int: calories = [94, 74, 73,119];

% Cost per unit of each food
array[FOODS] of int: cost = [7, 10, 9, 2];

% Minimum required daily intake
int: min_protein  = 84;
int: min_carbs    = 117;
int: min_calories = 1554;

% Derived practical upper bound on quantities (enough to meet calories alone)
int: max_qty = (min_calories div min(calories)) + 1;


% Variables
% Units selected of each food (non-negative integers)
array[FOODS] of var 0..max_qty: qty;

% Total cost and nutrients (bounded for linear objective/constraints)
var 0..(max(cost)     * max_qty): total_cost;
var 0..(max(protein)  * max_qty): total_protein;
var 0..(max(carbs)    * max_qty): total_carbs;
var 0..(max(calories) * max_qty): total_calories;


% Constraints
% Define totals
constraint total_cost     = sum(f in FOODS)(cost[f]     * qty[f]);
constraint total_protein  = sum(f in FOODS)(protein[f]  * qty[f]);
constraint total_carbs    = sum(f in FOODS)(carbs[f]    * qty[f]);
constraint total_calories = sum(f in FOODS)(calories[f] * qty[f]);

% --- Nutritional requirement constraints ---
constraint total_protein  >= min_protein;
constraint total_carbs    >= min_carbs;
constraint total_calories >= min_calories;


% Objective
solve minimize total_cost;