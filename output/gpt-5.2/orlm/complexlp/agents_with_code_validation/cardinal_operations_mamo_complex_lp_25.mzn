% Parameters
int: nFoods = 6;                      % Number of available food items
set of int: FOODS = 1..nFoods;        % Index set for foods

array[FOODS] of string: foodName =    % Names of foods (for readability)
  ["Chicken","Rice","Tuna","Beef","Corn","WheyProtein"];

array[FOODS] of int: cost =           % Cost per unit of each food
  [1, 9, 2, 9, 4, 6];

array[FOODS] of int: protein =        % Protein grams per unit
  [13, 1, 17, 15, 2, 15];

array[FOODS] of int: carbs =          % Carbohydrate grams per unit
  [27, 1, 2, 18, 19, 11];

array[FOODS] of int: calories =       % Calories per unit
  [81, 137, 53, 126, 117, 277];

int: minProtein  = 58;                % Minimum daily protein requirement
int: minCarbs    = 148;               % Minimum daily carbohydrate requirement
int: minCalories = 2454;              % Minimum daily calories requirement

% Variables
array[FOODS] of var 0..1000: qty;     % Nonnegative integer units of each food to buy/eat
var 0..1000000: totalCost;            % Total cost (bounded for linear safety)

% Constraints
% --- Total cost definition (linking variable totalCost to chosen quantities) ---
constraint
  totalCost = sum(f in FOODS)(cost[f] * qty[f]);

% --- Nutrition minimum requirements ---
constraint
  sum(f in FOODS)(protein[f] * qty[f]) >= minProtein;

constraint
  sum(f in FOODS)(carbs[f] * qty[f]) >= minCarbs;

constraint
  sum(f in FOODS)(calories[f] * qty[f]) >= minCalories;

% Objective
solve minimize totalCost;