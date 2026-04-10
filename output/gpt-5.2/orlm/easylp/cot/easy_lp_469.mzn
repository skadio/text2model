% Parameters (with values embedded)
int: total_hours_limit = 10;
int: min_effectiveness = 30;
int: max_diff = 2;

int: fatigue_x = 40;
int: fatigue_y = 60;

int: max_x = 6;
int: max_y = 8;

% Variables
var 0..max_x: X;
var 0..max_y: Y;
var 0..(fatigue_x*max_x + fatigue_y*max_y): total_fatigue;

% Constraints
constraint X + Y <= total_hours_limit;
constraint 3*X + 4*Y >= min_effectiveness;
constraint abs(X - Y) <= max_diff;

constraint total_fatigue = fatigue_x*X + fatigue_y*Y;

% Objective
solve minimize total_fatigue;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "minimum_total_fatigue = ", show(total_fatigue), "\n"
];