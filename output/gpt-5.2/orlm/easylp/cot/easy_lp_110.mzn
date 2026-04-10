% Parameters (with values embedded)
int: max_total_hours = 100;
int: min_diff_X_minus_Y = 10;
int: min_fitness_req = 60;

int: fatigue_per_hour_X = 2;
int: fatigue_per_hour_Y = 3;

% Variables
var 0..max_total_hours: X; % stamina building hours
var 0..max_total_hours: Y; % skill development hours

% Constraints
constraint X + Y <= max_total_hours;
constraint X >= Y + min_diff_X_minus_Y;
constraint 2 * X + Y >= min_fitness_req;

% Objective
var int: total_fatigue = fatigue_per_hour_X * X + fatigue_per_hour_Y * Y;

solve minimize total_fatigue;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "total_fatigue=", show(total_fatigue), "\n"
];