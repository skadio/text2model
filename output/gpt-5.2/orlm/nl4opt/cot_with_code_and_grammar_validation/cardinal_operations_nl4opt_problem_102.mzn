% Parameters
int: cost_rice = 3;
int: calories_rice = 300;
float: protein_rice = 4.5;

int: cost_kebab = 2;
int: calories_kebab = 200;
float: protein_kebab = 4.0;

int: min_calories = 2200;
float: min_protein = 30.0;

% Variables
var 0..100: rice_servings;
var 0..100: kebab_servings;

% Constraints
constraint
  calories_rice * rice_servings + calories_kebab * kebab_servings >= min_calories;

constraint
  protein_rice * rice_servings + protein_kebab * kebab_servings >= min_protein;

% Objective
solve minimize cost_rice * rice_servings + cost_kebab * kebab_servings;