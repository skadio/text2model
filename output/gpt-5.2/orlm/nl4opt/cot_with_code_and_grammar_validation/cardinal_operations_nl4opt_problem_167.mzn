% Parameters
int: min_calories = 2200;
int: min_protein  = 50;
int: min_carbs    = 70;

float: cost_hamburger = 6.5;
float: cost_wrap      = 4.0;

int: calories_hamburger = 800;
int: protein_hamburger  = 19;
int: carbs_hamburger    = 20;

int: calories_wrap = 450;
int: protein_wrap  = 12;
int: carbs_wrap    = 10;

% Variables
var 0..100: hamburgers;
var 0..100: wraps;
var float: total_cost;

% Constraints
constraint calories_hamburger * hamburgers + calories_wrap * wraps >= min_calories;
constraint protein_hamburger  * hamburgers + protein_wrap  * wraps >= min_protein;
constraint carbs_hamburger    * hamburgers + carbs_wrap    * wraps >= min_carbs;

constraint total_cost = cost_hamburger * hamburgers + cost_wrap * wraps;

% Objective
solve minimize total_cost;