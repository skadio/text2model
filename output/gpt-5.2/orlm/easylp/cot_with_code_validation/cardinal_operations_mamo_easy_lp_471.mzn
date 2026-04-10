% Parameters
int: fatigue_X = 10;
int: fatigue_Y = 20;

int: cap = 60;          % 3*X + 2*Y <= 60
int: min_total = 12;    % X + Y >= 12
int: max_diff = 8;      % |Y - X| <= 8

% Variables
var 0..cap: X;
var 0..cap: Y;

var 0..(fatigue_X*cap + fatigue_Y*cap): total_fatigue;

% Constraints
constraint 3*X + 2*Y <= cap;
constraint X + Y >= min_total;
constraint abs(Y - X) <= max_diff;

constraint total_fatigue = fatigue_X*X + fatigue_Y*Y;

% Objective
solve minimize total_fatigue;