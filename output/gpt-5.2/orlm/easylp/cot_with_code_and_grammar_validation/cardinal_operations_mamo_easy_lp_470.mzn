% Parameters
int: max_total_hours = 10;
int: min_diff = 1;                 % X >= Y + 1
int: eq_a = 2;                     % 2*X + 1*Y = 15
int: eq_b = 1;
int: eq_rhs = 15;

int: fatigue_X = 2;                % fatigue per hour of X
int: fatigue_Y = 3;                % fatigue per hour of Y

% Variables
var 0..max_total_hours: X;
var 0..max_total_hours: Y;
var 0..(fatigue_X*max_total_hours + fatigue_Y*max_total_hours): total_fatigue;

% Constraints
constraint X + Y <= max_total_hours;
constraint X >= Y + min_diff;
constraint eq_a * X + eq_b * Y = eq_rhs;

constraint total_fatigue = fatigue_X * X + fatigue_Y * Y;

% Objective
solve minimize total_fatigue;