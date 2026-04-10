% Training hours allocation to minimize fatigue (all data embedded)

int: max_total_hours = 15;
int: min_x = 5;          % strength conditioning minimum hours
int: min_y = 3;          % skill development minimum hours
int: fatigue_x = 20;     % fatigue units per hour of X
int: fatigue_y = 30;     % fatigue units per hour of Y

% Decision variables (whole hours)
var min_x..max_total_hours: X;
var min_y..max_total_hours: Y;

% Constraints
constraint X + Y <= max_total_hours;

% Objective: minimize total fatigue
var 0..fatigue_x*max_total_hours + fatigue_y*max_total_hours: total_fatigue;
constraint total_fatigue = fatigue_x * X + fatigue_y * Y;

solve minimize total_fatigue;

output [
  "X_hours = ", show(X), "\n",
  "Y_hours = ", show(Y), "\n",
  "Minimum total fatigue (rounded) = ", show(total_fatigue), "\n"
];