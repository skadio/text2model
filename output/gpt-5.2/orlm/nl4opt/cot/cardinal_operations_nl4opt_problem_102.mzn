% Parameters (with values embedded)
int: cost_rice = 3;
int: cost_kebab = 2;

int: calories_rice = 300;
int: calories_kebab = 200;

float: protein_rice = 4.5;
float: protein_kebab = 4.0;

int: min_calories = 2200;
float: min_protein = 30.0;

% Variables
var 0..100: rice;     % servings of rice per day
var 0..100: kebab;    % servings of kebab per day
var 0..500: total_cost;

% Constraints
constraint calories_rice * rice + calories_kebab * kebab >= min_calories;
constraint protein_rice * int2float(rice) + protein_kebab * int2float(kebab) >= min_protein;

constraint total_cost = cost_rice * rice + cost_kebab * kebab;

% Objective
solve minimize total_cost;