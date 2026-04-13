% Diet problem: minimize cost while meeting calorie and protein requirements

% Parameters
int: cost_rice  = 3;
int: cost_kebab = 2;

int: calories_rice  = 300;
int: calories_kebab = 200;

float: protein_rice  = 4.5;
float: protein_kebab = 4.0;

int: min_calories = 2200;
float: min_protein = 30.0;

% Simple safe upper bounds for integer servings
% (Enough to cover requirements even with one item, plus a small buffer)
int: ub_rice  = 20;
int: ub_kebab = 20;

% Decision variables: number of servings (nonnegative integers)
var 0..ub_rice:  servings_rice;
var 0..ub_kebab: servings_kebab;

% Total daily cost
var 0..(cost_rice * ub_rice + cost_kebab * ub_kebab): total_cost;

% Constraints
constraint total_cost = cost_rice * servings_rice + cost_kebab * servings_kebab;

constraint calories_rice * servings_rice + calories_kebab * servings_kebab >= min_calories;

constraint protein_rice * int2float(servings_rice) + protein_kebab * int2float(servings_kebab) >= min_protein;

% Objective
solve minimize total_cost;