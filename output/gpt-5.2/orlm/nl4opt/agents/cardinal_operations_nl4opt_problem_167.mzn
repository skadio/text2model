% Parameters
% Nutritional requirements (minimums)
int: min_calories = 2200;
int: min_protein  = 50;
int: min_carbs    = 70;

% Food item data
float: cost_hamburger = 6.5;
int: calories_hamburger = 800;
int: protein_hamburger  = 19;
int: carbs_hamburger    = 20;

float: cost_wrap = 4.0;
int: calories_wrap = 450;
int: protein_wrap  = 12;
int: carbs_wrap    = 10;

% Upper bounds on servings (safe bounds derived from meeting calories alone)
% These keep variables bounded while still allowing feasible minimum-cost solutions.
int: ub_hamburger =
  ceil(int2float(min_calories) / int2float(calories_hamburger)); % 3
int: ub_wrap =
  ceil(int2float(min_calories) / int2float(calories_wrap));      % 5

% Variables
% Number of each item to provide (nonnegative integers)
var 0..ub_hamburger: hamburgers;
var 0..ub_wrap: wraps;

% Total cost to minimize (bounded by the max possible cost given variable bounds)
var 0.0..(cost_hamburger*int2float(ub_hamburger) + cost_wrap*int2float(ub_wrap)): total_cost;

% Constraints
% Link total_cost to decision variables (linear cost aggregation)
constraint
  total_cost = cost_hamburger * int2float(hamburgers)
             + cost_wrap      * int2float(wraps);

% Meet minimum calorie requirement
constraint
  calories_hamburger * hamburgers + calories_wrap * wraps >= min_calories;

% Meet minimum protein requirement
constraint
  protein_hamburger * hamburgers + protein_wrap * wraps >= min_protein;

% Meet minimum carbohydrate requirement
constraint
  carbs_hamburger * hamburgers + carbs_wrap * wraps >= min_carbs;

% Objective
solve minimize total_cost;