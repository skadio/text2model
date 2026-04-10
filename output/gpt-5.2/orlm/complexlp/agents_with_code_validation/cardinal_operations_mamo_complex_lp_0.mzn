% Parameters
int: nFoods = 6;                       % Number of food items
set of int: FOODS = 1..nFoods;         % Food index set

array[FOODS] of string: foodName =     % Names of foods (for readability)
  ["Steak","Tofu","Chicken","Broccoli","Rice","Spinach"];

array[FOODS] of int: protein =         % Protein grams per serving
  [14, 2, 17, 3, 15, 2];

array[FOODS] of int: carbs =           % Carbohydrate grams per serving
  [23, 13, 13, 1, 23, 8];

array[FOODS] of int: calories =        % Calories per serving
  [63, 162, 260, 55, 231, 297];

array[FOODS] of int: cost =            % Cost per serving ($)
  [4, 6, 6, 8, 8, 5];

int: minProtein  = 83;                 % Minimum required protein
int: minCarbs    = 192;                % Minimum required carbohydrates
int: minCalories = 2089;               % Minimum required calories

% Variables
array[FOODS] of var 0..2089: servings; % Number of servings of each food (nonnegative, bounded)
var 0..(max(cost) * 2089): totalCost;  % Total cost (bounded)

% Constraints
% Link totalCost to chosen servings and per-serving costs
constraint
  totalCost = sum(f in FOODS)(cost[f] * servings[f]);

% Meet minimum protein requirement
constraint
  sum(f in FOODS)(protein[f] * servings[f]) >= minProtein;

% Meet minimum carbohydrate requirement
constraint
  sum(f in FOODS)(carbs[f] * servings[f]) >= minCarbs;

% Meet minimum calorie requirement
constraint
  sum(f in FOODS)(calories[f] * servings[f]) >= minCalories;

% Objective
solve minimize totalCost;