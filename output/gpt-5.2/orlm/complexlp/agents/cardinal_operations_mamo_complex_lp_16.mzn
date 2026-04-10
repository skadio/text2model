% Parameters
int: nFoods = 4;                           % number of food items
set of int: FOODS = 1..nFoods;             % index set for foods

array[FOODS] of string: foodName =
  ["Chicken", "Broccoli", "Beef", "Rice"]; % food item names (for readability/output)

array[FOODS] of int: cost =
  [5, 5, 8, 3];                            % cost per unit of each food

array[FOODS] of int: protein =
  [10, 4, 13, 15];                         % grams of protein per unit

array[FOODS] of int: carbs =
  [17, 3, 8, 25];                          % grams of carbohydrates per unit

array[FOODS] of int: calories =
  [159, 126, 230, 112];                    % calories per unit

int: minProtein  = 66;                     % minimum weekly protein target
int: minCarbs    = 101;                    % minimum weekly carbohydrate target
int: minCalories = 1701;                   % minimum weekly calorie target

% Variables
array[FOODS] of var 0..1000: qty;          % number of units of each food to consume (non-negative integers)
var 0..100000: totalCost;                  % total cost (bounded for linear expressions)

% Constraints
% ---- Total cost definition ----
constraint
  totalCost = sum(f in FOODS)(cost[f] * qty[f]);

% ---- Minimum protein requirement ----
constraint
  sum(f in FOODS)(protein[f] * qty[f]) >= minProtein;

% ---- Minimum carbohydrate requirement ----
constraint
  sum(f in FOODS)(carbs[f] * qty[f]) >= minCarbs;

% ---- Minimum calorie requirement ----
constraint
  sum(f in FOODS)(calories[f] * qty[f]) >= minCalories;

% Objective
solve minimize totalCost;