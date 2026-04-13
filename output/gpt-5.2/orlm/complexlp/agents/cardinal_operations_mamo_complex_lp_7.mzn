% Parameters
int: nFoods = 5;                              % Number of food items
set of int: FOODS = 1..nFoods;                % Index set for foods

% Food names (for readability/debugging)
array[FOODS] of string: food_name =
  ["Chicken", "Rice", "Apples", "Cheese", "Tofu"];

% Nutritional content per unit of each food
array[FOODS] of int: protein  = [14, 10, 4, 19, 10];      % grams protein
array[FOODS] of int: carbs    = [28, 27, 13, 5, 8];       % grams carbohydrates
array[FOODS] of int: calories = [184, 298, 162, 81, 147]; % calories

% Cost per unit of each food
array[FOODS] of int: cost = [5, 1, 5, 9, 9];              % dollars

% Minimum required totals
int: minProtein  = 97;
int: minCarbs    = 140;
int: minCalories = 2304;

% Variables
array[FOODS] of var 0..2304: qty;            % Nonnegative integer units of each food (safe upper bound)
var 0..(9*2304): totalCost;                  % Total cost (max cost * max units)

% Constraints
% --- Nutritional requirements: meet or exceed minimum totals ---
constraint
  sum(f in FOODS)(protein[f] * qty[f]) >= minProtein;

constraint
  sum(f in FOODS)(carbs[f] * qty[f]) >= minCarbs;

constraint
  sum(f in FOODS)(calories[f] * qty[f]) >= minCalories;

% --- Total cost definition ---
constraint
  totalCost = sum(f in FOODS)(cost[f] * qty[f]);

% Objective
solve minimize totalCost;