% Parameters
int: calcium_time = 5;
int: vitaminD_time = 6;

int: min_total_pills = 130;
int: min_vitaminD_pills = 40;

% Variables
var 0..min_total_pills: calcium;
var 0..min_total_pills: vitaminD;

var 0..(calcium_time * min_total_pills + vitaminD_time * min_total_pills): total_time;

% Constraints
constraint calcium + vitaminD >= min_total_pills;
constraint vitaminD >= min_vitaminD_pills;
constraint calcium > vitaminD;

constraint total_time = calcium_time * calcium + vitaminD_time * vitaminD;

% Objective
solve minimize total_time;