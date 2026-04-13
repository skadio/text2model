% Parameters
int: nFoods = 8;                                   % Number of food items
set of int: FOODS = 1..nFoods;                     % Index set for foods

% Food names (for readability/output)
array[FOODS] of string: foodName =
  ["Eggs","Grains","Berries","Nuts","Salmon","Vegetables","Rice","Meat"];

% Cost per unit of each food item ($)
array[FOODS] of int: cost =
  [4, 3, 2, 4, 9, 3, 6, 6];

% Nutrition per unit of each food item
array[FOODS] of int: protein =
  [2, 7, 6, 16, 20, 6, 6, 5];

array[FOODS] of int: carbs =
  [4, 9, 18, 3, 11, 27, 30, 1];

array[FOODS] of int: calories =
  [282, 104, 71, 116, 175, 132, 251, 74];

% Minimum daily requirements
int: minProtein = 84;
int: minCarbs = 195;
int: minCalories = 1941;


% Variables
array[FOODS] of var 0..1000: qty;                  % Quantity (units) selected for each food
var 0..1000000: totalCost;                         % Total cost of selected foods ($)
var 0..1000000: totalProtein;                      % Total protein from selection (g)
var 0..1000000: totalCarbs;                        % Total carbohydrates from selection (g)
var 0..1000000: totalCalories;                     % Total calories from selection


% Constraints
% --- Aggregate totals from chosen quantities ---
constraint totalCost = sum(f in FOODS)(cost[f] * qty[f]);
constraint totalProtein = sum(f in FOODS)(protein[f] * qty[f]);
constraint totalCarbs = sum(f in FOODS)(carbs[f] * qty[f]);
constraint totalCalories = sum(f in FOODS)(calories[f] * qty[f]);

% --- Meet minimum daily nutrition requirements ---
constraint totalProtein >= minProtein;
constraint totalCarbs >= minCarbs;
constraint totalCalories >= minCalories;


% Objective
solve minimize totalCost;