% Parameters
int: total_hours_limit = 10;
int: min_effectiveness = 30;
int: max_diff = 2;

int: eff_x = 3;
int: eff_y = 4;

int: fat_x = 40;
int: fat_y = 60;

int: max_x = 6;
int: max_y = 8;

% Variables
var 0..max_x: X;
var 0..max_y: Y;
var 0..(fat_x*max_x + fat_y*max_y): total_fatigue;

% Constraints
constraint X + Y <= total_hours_limit;
constraint eff_x * X + eff_y * Y >= min_effectiveness;
constraint abs(X - Y) <= max_diff;

constraint total_fatigue = fat_x * X + fat_y * Y;

% Objective
solve minimize total_fatigue;