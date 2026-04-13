% Parameters
int: nFoods = 5;                             % number of food items
set of int: FOODS = 1..nFoods;               % index set for foods

array[FOODS] of string: foodName =           % food names (for readability)
  ["Chicken","Pasta","Apples","Tuna","Rice"];

array[FOODS] of int: protein =               % grams of protein per unit
  [8, 10, 3, 16, 4];

array[FOODS] of int: carbs =                 % grams of carbohydrates per unit
  [8, 30, 10, 29, 24];

array[FOODS] of int: calories =              % calories per unit
  [118, 131, 151, 235, 101];

array[FOODS] of int: price =                 % cost per unit ($)
  [6, 10, 1, 9, 4];

int: minProtein  = 93;                       % required minimum protein
int: minCarbs    = 181;                      % required minimum carbohydrates
int: minCalories = 1620;                     % required minimum calories

% Variables
array[FOODS] of var 0..1000: qty;            % integer units of each food (bounded non-negative)
var 0..100000: totalCost;                    % total cost (bounded for linear objective)

% Constraints
% --- Nutritional requirement constraints (meet or exceed daily minimums) ---
constraint
  sum(f in FOODS)(protein[f] * qty[f]) >= minProtein;

constraint
  sum(f in FOODS)(carbs[f] * qty[f]) >= minCarbs;

constraint
  sum(f in FOODS)(calories[f] * qty[f]) >= minCalories;

% --- Cost aggregation constraint (define totalCost from chosen quantities) ---
constraint
  totalCost = sum(f in FOODS)(price[f] * qty[f]);

% Objective
solve minimize totalCost;