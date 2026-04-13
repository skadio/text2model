% Parameters
int: prot_smoothie = 2;
int: cal_smoothie  = 300;
int: prot_bar      = 7;
int: cal_bar       = 250;

int: max_calories  = 2000;

% Variables
var 0..(max_calories div cal_smoothie): smoothies;
var 0..(max_calories div cal_bar): bars;

var 0..(prot_smoothie*(max_calories div cal_smoothie) + prot_bar*(max_calories div cal_bar)): total_protein;

% Constraints
constraint bars = 2 * smoothies;
constraint cal_smoothie * smoothies + cal_bar * bars <= max_calories;
constraint total_protein = prot_smoothie * smoothies + prot_bar * bars;

% Objective
solve maximize total_protein;