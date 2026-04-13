% Parameters (with values embedded)
int: max_total_hours = 10;
int: min_diff = 1;                 % X >= Y + 1
int: eq_lhs_X_coeff = 2;           % 2*X + Y == 15
int: eq_rhs = 15;
int: fatigue_per_X = 2;
int: fatigue_per_Y = 3;

% Variables
var 0..max_total_hours: X;         % strength conditioning hours (integer)
var 0..max_total_hours: Y;         % skill development hours (integer)
var 0..(fatigue_per_X*max_total_hours + fatigue_per_Y*max_total_hours): total_fatigue;

% Constraints
constraint X + Y <= max_total_hours;
constraint X >= Y + min_diff;
constraint eq_lhs_X_coeff * X + Y = eq_rhs;
constraint total_fatigue = fatigue_per_X * X + fatigue_per_Y * Y;

% Objective
solve minimize total_fatigue;