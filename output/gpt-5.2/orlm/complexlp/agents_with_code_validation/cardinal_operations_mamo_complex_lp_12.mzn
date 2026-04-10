% Parameters
int: nFoods = 4;                         % number of available foods
set of int: FOODS = 1..nFoods;           % index set for foods

array[FOODS] of int: protein  = [2, 11, 19, 17];     % grams of protein per serving
array[FOODS] of int: carbs    = [9, 29, 16, 9];      % grams of carbohydrates per serving
array[FOODS] of int: calories = [165, 230, 68, 258]; % calories per serving
array[FOODS] of int: cost     = [3, 3, 6, 9];        % cost per serving

int: minProtein  = 88;                   % minimum required protein (g)
int: minCarbs    = 107;                  % minimum required carbohydrates (g)
int: minCalories = 1944;                 % minimum required calories

% Variables
array[FOODS] of var 0..1000: servings;   % integer servings of each food (nonnegative)
var 0..100000: totalCost;                % total cost to minimize

% Constraints
% --- Total cost definition ---
constraint
  totalCost = sum(f in FOODS)(cost[f] * servings[f]);

% --- Nutritional minimum requirements ---
constraint
  sum(f in FOODS)(protein[f] * servings[f]) >= minProtein;

constraint
  sum(f in FOODS)(carbs[f] * servings[f]) >= minCarbs;

constraint
  sum(f in FOODS)(calories[f] * servings[f]) >= minCalories;

% Objective
solve minimize totalCost;