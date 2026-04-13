% Parameters
int: nFoods = 6;                                   % number of foods
set of int: FOODS = 1..nFoods;                     % food indices

array[FOODS] of string: foodName =
  ["Chicken","Rice","Vegetables","Bread","Almonds","Salmon"];

array[FOODS] of int: protein  = [16, 11,  1,  6,  2, 19];   % grams protein per unit
array[FOODS] of int: carbs    = [ 8, 24,  5, 26, 11, 20];   % grams carbs per unit
array[FOODS] of int: calories = [50, 90,164,165, 51,238];   % calories per unit
array[FOODS] of int: cost     = [ 2,  3,  3,  2,  4, 10];   % dollars per unit

int: minProtein  = 58;                             % required minimum protein
int: minCarbs    = 150;                            % required minimum carbs
int: minCalories = 2392;                           % required minimum calories

% Safe upper bound for servings (very loose but valid)
int: maxServings = minCalories;

% Variables
array[FOODS] of var 0..maxServings: servings;      % integer units of each food
var 0..(maxServings * max(cost)): totalCost;       % total cost to minimize

% Constraints
% Link totalCost to chosen servings and per-food costs
constraint
  totalCost = sum(f in FOODS)(servings[f] * cost[f]);

% Meet minimum protein requirement
constraint
  sum(f in FOODS)(servings[f] * protein[f]) >= minProtein;

% Meet minimum carbohydrate requirement
constraint
  sum(f in FOODS)(servings[f] * carbs[f]) >= minCarbs;

% Meet minimum calorie requirement
constraint
  sum(f in FOODS)(servings[f] * calories[f]) >= minCalories;

% Objective
solve minimize totalCost;