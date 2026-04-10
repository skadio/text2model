% Parameters
int: intensity_X = 8;
int: intensity_Y = 12;
int: max_time = 20;
int: eff_coef_X = 5;
int: eff_coef_Y = 3;
int: min_effectiveness = 15;

% Variables
var 0..max_time: hours_X;
var 0..max_time: hours_Y;
var 0..(intensity_X*max_time + intensity_Y*max_time): total_intensity;

% Constraints
constraint hours_X + hours_Y <= max_time;

constraint eff_coef_X * hours_X + eff_coef_Y * hours_Y >= min_effectiveness;

constraint total_intensity = intensity_X * hours_X + intensity_Y * hours_Y;

% Objective
solve minimize total_intensity;