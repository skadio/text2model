% Parameters
int: nFoods = 5;                       % number of available food items
set of int: FOODS = 1..nFoods;         % index set for foods

array[FOODS] of string: foodName =
  ["Chicken", "Rice", "Broccoli", "Tofu", "Beans"]; % food item names

array[FOODS] of int: cost     = [4, 8, 7, 10, 1];           % cost per unit
array[FOODS] of int: protein  = [18, 12, 13, 5, 10];        % grams protein per unit
array[FOODS] of int: carbs    = [6, 28, 19, 16, 20];        % grams carbs per unit
array[FOODS] of int: calories = [142, 88, 137, 141, 150];   % calories per unit

int: minProtein  = 56;     % minimum required protein (g)
int: minCarbs    = 194;    % minimum required carbohydrates (g)
int: minCalories = 2012;   % minimum required calories

% Variables
array[FOODS] of var 0..1000: qty;   % nonnegative integer quantity of each food item
var 0..100000: totalCost;           % total cost (bounded for linear expressions)

% Constraints
% --- Total cost definition ---
constraint
  totalCost = sum(f in FOODS)(cost[f] * qty[f]);

% --- Nutritional minimum requirements ---
constraint
  sum(f in FOODS)(protein[f] * qty[f]) >= minProtein;

constraint
  sum(f in FOODS)(carbs[f] * qty[f]) >= minCarbs;

constraint
  sum(f in FOODS)(calories[f] * qty[f]) >= minCalories;

% Objective
solve minimize totalCost;