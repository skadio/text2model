% Parameters
int: max_total_matches = 50;
int: min_competitiveness = 30;
int: max_balance_diff = 10;

int: fatigue_X = 4;
int: fatigue_Y = 3;

% Variables
var 0..max_total_matches: x; % matches in sport X
var 0..max_total_matches: y; % matches in sport Y

var 0..(fatigue_X*max_total_matches + fatigue_Y*max_total_matches): total_fatigue;

% Constraints
constraint x + y <= max_total_matches;
constraint 2 * x + y >= min_competitiveness;
constraint abs(x - 2 * y) <= max_balance_diff;

constraint total_fatigue = fatigue_X * x + fatigue_Y * y;

% Objective
solve minimize total_fatigue;