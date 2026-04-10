% Parameters
int: max_matches = 50;
int: min_competitiveness = 30;
int: max_balance_diff = 10;

int: fatigue_x = 4;
int: fatigue_y = 3;

% Variables
var 0..max_matches: x; % matches of sport X
var 0..max_matches: y; % matches of sport Y
var 0..(fatigue_x*max_matches + fatigue_y*max_matches): total_fatigue;

% Constraints
constraint x + y <= max_matches;
constraint 2*x + y >= min_competitiveness;
constraint abs(x - 2*y) <= max_balance_diff;

constraint total_fatigue = fatigue_x*x + fatigue_y*y;

% Objective
solve minimize total_fatigue;