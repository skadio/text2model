% Parameters (with values embedded)
int: max_total_hours = 40;
int: min_X_hours = 15;
int: min_Y_hours = 10;
int: fatigue_X = 2;
int: fatigue_Y = 3;

% Variables
var 0..max_total_hours: X;
var 0..max_total_hours: Y;
var 0..(fatigue_X*max_total_hours + fatigue_Y*max_total_hours): total_fatigue;

% Constraints
constraint X >= min_X_hours;
constraint Y >= min_Y_hours;
constraint X + Y <= max_total_hours;
constraint total_fatigue = fatigue_X * X + fatigue_Y * Y;

% Objective
solve minimize total_fatigue;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum total fatigue = ", show(total_fatigue), "\n"
];