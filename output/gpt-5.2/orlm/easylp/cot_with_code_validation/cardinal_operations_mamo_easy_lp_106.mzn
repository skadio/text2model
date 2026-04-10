% Parameters
int: intensity_x = 8;
int: intensity_y = 12;
int: max_total_hours = 20;
int: eff_x = 5;
int: eff_y = 3;
int: min_effectiveness = 15;

% Variables
var 0..max_total_hours: hours_x;
var 0..max_total_hours: hours_y;
var 0..(intensity_x * max_total_hours + intensity_y * max_total_hours): total_intensity;

% Constraints
constraint hours_x + hours_y <= max_total_hours;
constraint eff_x * hours_x + eff_y * hours_y >= min_effectiveness;
constraint total_intensity = intensity_x * hours_x + intensity_y * hours_y;

% Objective
solve minimize total_intensity;