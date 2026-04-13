% Diet LP as a finite-domain MIP (avoid float vars that can lead to slow solving)
include "float.mzn";

% Parameters (embedded data)
float: cost_noodles = 5.0;
float: calories_noodles = 600.0;
float: protein_noodles = 1.5;

float: cost_bar = 2.5;
float: calories_bar = 250.0;
float: protein_bar = 5.0;

float: min_calories = 2000.0;
float: min_protein = 16.0;

% Use integer servings (typical for discrete servings; also speeds up solving)
int: max_servings = 100;

var 0..max_servings: servings_noodles;
var 0..max_servings: servings_bar;

% Nutrition constraints (use float comparisons via float() conversion)
constraint
  calories_noodles * float(servings_noodles) +
  calories_bar     * float(servings_bar) >= min_calories;

constraint
  protein_noodles * float(servings_noodles) +
  protein_bar     * float(servings_bar) >= min_protein;

% Objective: minimize total cost (computed inline)
solve minimize
  cost_noodles * float(servings_noodles) +
  cost_bar     * float(servings_bar);

output [
  "servings_noodles = ", show(servings_noodles), "\n",
  "servings_bar = ", show(servings_bar), "\n",
  "total_cost = ", show(cost_noodles * float(servings_noodles) + cost_bar * float(servings_bar)), "\n",
  "total_calories = ", show(calories_noodles * float(servings_noodles) + calories_bar * float(servings_bar)), "\n",
  "total_protein = ", show(protein_noodles * float(servings_noodles) + protein_bar * float(servings_bar)), "\n"
];