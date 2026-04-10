% Parameters
int: cap_balloon = 4;
int: cap_gondola = 6;
int: pol_balloon = 10;
int: pol_gondola = 15;
int: max_balloon = 10;
int: min_visitors = 70;

% Variables
var 0..max_balloon: n_balloon;
var 0..ceil(int2float(min_visitors) / int2float(cap_gondola)): n_gondola;
var 0..(pol_balloon*max_balloon + pol_gondola*ceil(int2float(min_visitors)/int2float(cap_gondola))): total_pollution;

% Constraints
constraint cap_balloon * n_balloon + cap_gondola * n_gondola >= min_visitors;

constraint total_pollution = pol_balloon * n_balloon + pol_gondola * n_gondola;

% Objective
solve minimize total_pollution;