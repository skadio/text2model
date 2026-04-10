% Parameters
% Nutrient content per serving (grams)
int: calcium_A = 30;
int: magnesium_A = 50;
int: calcium_B = 60;
int: magnesium_B = 10;

% Cost per serving ($)
int: cost_A = 14;
int: cost_B = 25;

% Minimum daily requirements (grams)
int: min_calcium = 400;
int: min_magnesium = 50;

% Variables
% Number of servings of each supplement (nonnegative integers)
var 0..1000: servings_A;
var 0..1000: servings_B;

% Total daily cost ($)
var 0..100000: total_cost;

% Constraints
% Nutritional requirements: meet minimum daily Calcium intake
constraint calcium_A * servings_A + calcium_B * servings_B >= min_calcium;

% Nutritional requirements: meet minimum daily Magnesium intake
constraint magnesium_A * servings_A + magnesium_B * servings_B >= min_magnesium;

% Cost definition: link total_cost to servings and per-serving costs
constraint total_cost = cost_A * servings_A + cost_B * servings_B;

% Objective
solve minimize total_cost;