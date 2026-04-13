% Parameters
int: protein_smoothie = 2;
int: cal_smoothie = 300;
int: protein_bar = 7;
int: cal_bar = 250;
int: max_cal = 2000;

% Variables
var 0..(max_cal div cal_smoothie): smoothies;
var 0..(max_cal div cal_bar): bars;

% Constraints
constraint bars = 2 * smoothies;
constraint cal_smoothie * smoothies + cal_bar * bars <= max_cal;

% Objective
solve maximize protein_smoothie * smoothies + protein_bar * bars;