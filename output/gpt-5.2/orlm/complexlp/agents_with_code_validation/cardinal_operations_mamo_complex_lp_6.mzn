% Parameters
int: nFoods = 5;                         % number of foods
set of int: FOODS = 1..nFoods;           % index set for foods

array[FOODS] of int: protein  = [10, 3, 17, 6, 20];       % grams of protein per unit
array[FOODS] of int: carbs    = [22, 4, 10, 13, 5];       % grams of carbohydrates per unit
array[FOODS] of int: calories = [80, 189, 153, 232, 204]; % calories per unit
array[FOODS] of int: cost     = [2, 8, 4, 1, 8];          % cost per unit ($)

int: minProtein  = 74;                   % required minimum protein
int: minCarbs    = 102;                  % required minimum carbohydrates
int: minCalories = 1564;                 % required minimum calories

% Variables
array[FOODS] of var 0..1000: qty;        % number of units chosen of each food (non-negative integers)
var 0..1000000: totalCost;               % total cost to minimize
var 0..1000000: totalProtein;            % total protein achieved
var 0..1000000: totalCarbs;              % total carbohydrates achieved
var 0..1000000: totalCalories;           % total calories achieved

% Constraints
% Compute total nutrient amounts from chosen quantities
constraint
  totalProtein = sum(f in FOODS)(protein[f] * qty[f]);

constraint
  totalCarbs = sum(f in FOODS)(carbs[f] * qty[f]);

constraint
  totalCalories = sum(f in FOODS)(calories[f] * qty[f]);

% Compute total cost from chosen quantities
constraint
  totalCost = sum(f in FOODS)(cost[f] * qty[f]);

% Meet minimum nutrition requirements
constraint
  totalProtein >= minProtein;

constraint
  totalCarbs >= minCarbs;

constraint
  totalCalories >= minCalories;

% Objective
solve minimize totalCost;