% Parameters (with values embedded)
float: cost_noodles = 5.0;
int: calories_noodles = 600;
float: protein_noodles = 1.5;

float: cost_bar = 2.5;
int: calories_bar = 250;
int: protein_bar = 5;

int: min_calories = 2000;
float: min_protein = 16.0;

% Variables
var 0..100: noodles;          % servings of noodles per day
var 0..100: bars;             % servings of protein bars per day

var float: total_cost;
var 0..100000: total_calories;
var float: total_protein;

% Constraints
constraint total_cost = cost_noodles * noodles + cost_bar * bars;
constraint total_calories = calories_noodles * noodles + calories_bar * bars;
constraint total_protein = protein_noodles * noodles + protein_bar * bars;

constraint total_calories >= min_calories;
constraint total_protein >= min_protein;

% Objective
solve minimize total_cost;