% Parameters (with values embedded)
int: max_total_hours = 100;
int: cost_nurse = 500;
int: cost_doctor = 300;
int: cost_admin = 700;

% Variables
var 0..max_total_hours: X; % nurses hours
var 0..max_total_hours: Y; % doctors hours
var 0..max_total_hours: Z; % administrative hours

% Constraints
constraint X + Y + Z <= max_total_hours;

% difference between nurses and doctors must be at least 10 (absolute difference)
constraint abs(X - Y) >= 10;

% difference between admin and nurses should not exceed 20 (absolute difference)
constraint abs(Z - X) <= 20;

% at least 30 more admin hours than doctor hours
constraint Z >= Y + 30;

% Objective
solve minimize cost_nurse * X + cost_doctor * Y + cost_admin * Z;