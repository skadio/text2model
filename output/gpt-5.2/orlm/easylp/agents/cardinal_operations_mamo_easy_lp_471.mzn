% Parameters
% Fatigue score per hour for each group
int: fatigue_X = 10;
int: fatigue_Y = 20;

% Constraint coefficients and bounds
int: coeff_X_facility = 3;     % coefficient for X in facility/trainer constraint
int: coeff_Y_facility = 2;     % coefficient for Y in facility/trainer constraint
int: max_facility_hours = 60;  % upper bound for 3*X + 2*Y

int: min_total_hours = 12;     % lower bound for X + Y
int: max_diff_hours = 8;       % upper bound for |Y - X|

% Upper bounds for decision variables (safe from constraints)
% From 3*X + 2*Y <= 60 and non-negativity:
int: max_X = max_facility_hours div coeff_X_facility;  % 20
int: max_Y = max_facility_hours div coeff_Y_facility;  % 30

% Variables
var 0..max_X: hours_X;  % weekly training hours for group X (strength conditioning)
var 0..max_Y: hours_Y;  % weekly training hours for group Y (skill development)

% Total fatigue (objective value), bounded by max possible fatigue under variable bounds
var 0..(fatigue_X * max_X + fatigue_Y * max_Y): total_fatigue;

% Constraints
% Link total fatigue to training-hour decisions
constraint
  total_fatigue = fatigue_X * hours_X + fatigue_Y * hours_Y;

% Facility/trainer capacity constraint: 3*X + 2*Y must not exceed 60
constraint
  coeff_X_facility * hours_X + coeff_Y_facility * hours_Y <= max_facility_hours;

% Minimum total training hours for a balanced program: X + Y >= 12
constraint
  hours_X + hours_Y >= min_total_hours;

% Difference limit between groups: |Y - X| <= 8
constraint
  abs(hours_Y - hours_X) <= max_diff_hours;

% Objective
solve minimize total_fatigue;