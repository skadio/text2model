% Parameters (with values embedded)
int: cap_balloon = 4;
int: cap_gondola = 6;
int: pol_balloon = 10;
int: pol_gondola = 15;
int: max_balloon = 10;
int: min_visitors = 70;

% Variables
var 0..max_balloon: balloon;
var 0..ceil(min_visitors div cap_gondola) + max_balloon: gondola; % safe upper bound

% Constraints
constraint cap_balloon * balloon + cap_gondola * gondola >= min_visitors;

% Objective
solve minimize pol_balloon * balloon + pol_gondola * gondola;