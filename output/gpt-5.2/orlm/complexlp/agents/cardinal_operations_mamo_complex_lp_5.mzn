% Parameters
int: nFoods = 9;                           % number of food items
set of int: FOODS = 1..nFoods;            % index set for foods

array[FOODS] of string: foodName =
  ["Chicken","Rice","Apples","Steak","Lentils","Fish","Tofu","Cheese","Bread"];

array[FOODS] of int: protein =            % grams of protein per unit
  [15, 1, 1, 6, 3, 17, 18, 12, 2];

array[FOODS] of int: carbs =              % grams of carbohydrates per unit
  [18, 25, 21, 3, 7, 13, 27, 17, 30];

array[FOODS] of int: calories =           % calories per unit
  [300, 267, 266, 119, 166, 129, 216, 76, 258];

array[FOODS] of int: cost =               % cost ($) per unit
  [4, 2, 5, 10, 2, 8, 10, 9, 4];

int: minProtein  = 90;                    % minimum daily protein requirement
int: minCarbs    = 105;                   % minimum daily carbohydrates requirement
int: minCalories = 1805;                  % minimum daily calories requirement

% Variables
array[FOODS] of var 0..1000: qty;         % integer units chosen for each food (bounded)
var 0..1000000: totalCost;                % total cost to minimize (bounded)

% Constraints
% --- Nutritional requirement constraints ---
constraint
  sum(f in FOODS)(protein[f] * qty[f]) >= minProtein;

constraint
  sum(f in FOODS)(carbs[f] * qty[f]) >= minCarbs;

constraint
  sum(f in FOODS)(calories[f] * qty[f]) >= minCalories;

% --- Total cost definition constraint ---
constraint
  totalCost = sum(f in FOODS)(cost[f] * qty[f]);

% Objective
solve minimize totalCost;

output [show(totalCost)];