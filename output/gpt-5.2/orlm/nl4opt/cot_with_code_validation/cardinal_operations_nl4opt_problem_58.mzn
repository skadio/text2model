% Parameters
int: calcium_time = 5;
int: vitaminD_time = 6;
int: min_total_pills = 130;
int: min_vitaminD_pills = 40;

% Variables
var 0..min_total_pills: calcium_pills;
var 0..min_total_pills: vitaminD_pills;
var 0..(calcium_time*min_total_pills + vitaminD_time*min_total_pills): total_time;

% Constraints
constraint calcium_pills + vitaminD_pills >= min_total_pills;
constraint vitaminD_pills >= min_vitaminD_pills;
constraint calcium_pills > vitaminD_pills;

constraint total_time = calcium_time * calcium_pills + vitaminD_time * vitaminD_pills;

% Objective
solve minimize total_time;