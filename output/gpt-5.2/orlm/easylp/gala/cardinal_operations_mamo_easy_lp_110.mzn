include "globals.mzn";

% Data (embedded as requested)
int: max_total_hours = 100;
int: min_diff_X_over_Y = 10;
int: min_fitness = 60;

int: fatigue_X = 2;
int: fatigue_Y = 3;

% Decision variables: whole numbers of training hours
var 0..max_total_hours: X;  % stamina building hours
var 0..max_total_hours: Y;  % skill development hours

% Objective: minimize total fatigue score
var 0..(fatigue_X*max_total_hours + fatigue_Y*max_total_hours): total_fatigue;
constraint total_fatigue = fatigue_X * X + fatigue_Y * Y;

% Constraints
constraint X + Y <= max_total_hours;
constraint X >= Y + min_diff_X_over_Y;
constraint 2 * X + Y >= min_fitness;

solve minimize total_fatigue;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum total fatigue (rounded) = ", show(total_fatigue), "\n"
];