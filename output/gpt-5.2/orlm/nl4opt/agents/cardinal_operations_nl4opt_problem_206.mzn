% Parameters
% Nutrient content per serving (grams)
int: calcium_A = 30;
int: magnesium_A = 50;
int: calcium_B = 60;
int: magnesium_B = 10;

% Cost per serving ($)
int: cost_A = 14;
int: cost_B = 25;

% Daily minimum requirements (grams)
int: min_calcium = 400;
int: min_magnesium = 50;

% Variables
% Number of servings per day (non-negative integers)
var 0..1000: servings_A;
var 0..1000: servings_B;

% Total daily cost to minimize ($)
var 0..(cost_A*1000 + cost_B*1000): total_cost;

% Constraints
% Link total_cost to chosen servings
constraint
  total_cost = cost_A * servings_A + cost_B * servings_B;

% Meet minimum daily Calcium requirement
constraint
  calcium_A * servings_A + calcium_B * servings_B >= min_calcium;

% Meet minimum daily Magnesium requirement
constraint
  magnesium_A * servings_A + magnesium_B * servings_B >= min_magnesium;

% Objective
solve minimize total_cost;