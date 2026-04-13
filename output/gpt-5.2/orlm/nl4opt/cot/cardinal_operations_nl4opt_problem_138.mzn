% Parameters (with values embedded)
int: protein_smoothie = 2;
int: calories_smoothie = 300;
int: protein_bar = 7;
int: calories_bar = 250;
int: max_calories = 2000;

% Variables
var 0..6: smoothies;
var 0..8: bars;
var 0..100: total_protein;

% Constraints
constraint bars = 2 * smoothies;
constraint calories_smoothie * smoothies + calories_bar * bars <= max_calories;

constraint total_protein = protein_smoothie * smoothies + protein_bar * bars;

% Objective
solve maximize total_protein;