% Parameters
% Costs per serving ($)
int: cost_rice = 3;
int: cost_kebab = 2;

% Nutrition per serving
int: calories_rice = 300;
int: calories_kebab = 200;

float: protein_rice = 4.5;
float: protein_kebab = 4.0;

% Daily minimum requirements
int: min_calories = 2200;
float: min_protein = 30.0;

% Upper bounds for servings (safe finite bounds for an unbounded >=-type minimization)
% Use float division for calorie bounds, then ceil to int.
int: max_rice =
  max( ceil(int2float(min_calories) / int2float(calories_rice)) + 1,
       ceil(min_protein / protein_rice) + 1 );

int: max_kebab =
  max( ceil(int2float(min_calories) / int2float(calories_kebab)) + 1,
       ceil(min_protein / protein_kebab) + 1 );

% Variables
% Number of servings per day (non-negative integers)
var 0..max_rice: servings_rice;
var 0..max_kebab: servings_kebab;

% Total daily cost ($)
var 0..(cost_rice * max_rice + cost_kebab * max_kebab): total_cost;

% Constraints
% Link total_cost to chosen servings and their costs
constraint
  total_cost = cost_rice * servings_rice + cost_kebab * servings_kebab;

% Ensure minimum daily calories requirement is met
constraint
  calories_rice * servings_rice + calories_kebab * servings_kebab >= min_calories;

% Ensure minimum daily protein requirement is met
constraint
  protein_rice * int2float(servings_rice) + protein_kebab * int2float(servings_kebab) >= min_protein;

% Objective
solve minimize total_cost;