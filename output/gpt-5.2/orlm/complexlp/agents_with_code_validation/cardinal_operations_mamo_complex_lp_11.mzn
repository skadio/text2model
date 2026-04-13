% Parameters
int: nFoods = 5;                          % Number of available foods
set of int: FOODS = 1..nFoods;            % Index set for foods

array[FOODS] of string: foodName =        % Food names (for readability)
  ["Chicken","Pasta","Rice","Beans","Cheese"];

array[FOODS] of int: cost =               % Cost per unit of each food ($)
  [7, 10, 7, 9, 7];

array[FOODS] of int: protein =            % Protein per unit (grams)
  [5, 3, 11, 10, 4];

array[FOODS] of int: carbs =              % Carbohydrates per unit (grams)
  [13, 23, 27, 27, 18];

array[FOODS] of int: calories =           % Calories per unit
  [121, 274, 251, 259, 199];

int: minProtein = 60;                     % Minimum required protein (grams)
int: minCarbs = 146;                      % Minimum required carbohydrates (grams)
int: minCalories = 1727;                  % Minimum required calories


% Variables
array[FOODS] of var 0..1000: qty;         % Integer units of each food to buy

var 0..1000000: totalCost;                % Total cost ($)
var 0..1000000: totalProtein;             % Total protein (grams)
var 0..1000000: totalCarbs;               % Total carbohydrates (grams)
var 0..1000000: totalCalories;            % Total calories


% Constraints
% --- Totals definition constraints (link aggregate totals to chosen quantities) ---
constraint
  totalCost = sum(f in FOODS)(cost[f] * qty[f]);

constraint
  totalProtein = sum(f in FOODS)(protein[f] * qty[f]);

constraint
  totalCarbs = sum(f in FOODS)(carbs[f] * qty[f]);

constraint
  totalCalories = sum(f in FOODS)(calories[f] * qty[f]);

% --- Nutritional minimum requirements ---
constraint
  totalProtein >= minProtein;

constraint
  totalCarbs >= minCarbs;

constraint
  totalCalories >= minCalories;


% Objective
solve minimize totalCost;