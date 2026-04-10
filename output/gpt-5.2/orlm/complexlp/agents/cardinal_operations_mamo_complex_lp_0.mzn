% Parameters
int: nFoods = 6;                         % number of food items
set of int: FOODS = 1..nFoods;           % index set for foods

array[FOODS] of string: foodName =
  ["Steak","Tofu","Chicken","Broccoli","Rice","Spinach"];  % food names (for readability)

array[FOODS] of int: protein =
  [14, 2, 17, 3, 15, 2];                 % grams of protein per unit of each food

array[FOODS] of int: carbs =
  [23, 13, 13, 1, 23, 8];                % grams of carbohydrates per unit of each food

array[FOODS] of int: calories =
  [63, 162, 260, 55, 231, 297];          % calories per unit of each food

array[FOODS] of int: cost =
  [4, 6, 6, 8, 8, 5];                    % cost ($) per unit of each food

int: minProtein = 83;                    % minimum required protein
int: minCarbs   = 192;                   % minimum required carbohydrates
int: minCalories = 2089;                 % minimum required calories


% Variables
array[FOODS] of var 0..1000: qty;        % number of units chosen for each food (nonnegative integer)
var int: totalCost;                      % total cost of the chosen quantities


% Constraints
% --- Total cost definition ---
constraint
  totalCost = sum(f in FOODS)(cost[f] * qty[f]);

% --- Minimum nutrition requirements ---
constraint
  sum(f in FOODS)(protein[f] * qty[f]) >= minProtein;

constraint
  sum(f in FOODS)(carbs[f] * qty[f]) >= minCarbs;

constraint
  sum(f in FOODS)(calories[f] * qty[f]) >= minCalories;


% Objective
solve minimize totalCost;