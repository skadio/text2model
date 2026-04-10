% Parameters
int: cap_balloon = 4;
int: cap_gondola = 6;
int: pol_balloon = 10;
int: pol_gondola = 15;
int: max_balloon = 10;
int: min_visitors = 70;

% Variables
var 0..max_balloon: x_balloon;
var 0..ceil(min_visitors div cap_gondola) + max_balloon: x_gondola;

% Constraints
constraint cap_balloon * x_balloon + cap_gondola * x_gondola >= min_visitors;

% Objective
solve minimize pol_balloon * x_balloon + pol_gondola * x_gondola;