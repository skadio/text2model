% Parameters (with values embedded)
int: fatigue_X = 10;
int: fatigue_Y = 20;

int: max_facility = 60;

% Variables
var 0..60: X; % weekly hours for group X (strength conditioning)
var 0..60: Y; % weekly hours for group Y (skill development)

% Constraints
constraint 3 * X + 2 * Y <= max_facility;
constraint X + Y >= 12;
constraint abs(Y - X) <= 8;

% Objective
solve minimize fatigue_X * X + fatigue_Y * Y;