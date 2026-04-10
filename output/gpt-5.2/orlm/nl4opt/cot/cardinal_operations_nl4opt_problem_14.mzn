% Parameters (with values embedded)
int: scooter_capacity = 2;
int: rickshaw_capacity = 3;
int: min_visitors = 300;
float: max_rickshaw_fraction = 0.40;

% Variables
var 0..150: scooters;     % 150 scooters alone can carry 300 visitors
var 0..150: rickshaws;    % bound sufficient given the 40% constraint and demand

% Constraints
constraint scooter_capacity * scooters + rickshaw_capacity * rickshaws >= min_visitors;
constraint rickshaws <= floor(max_rickshaw_fraction * int2float(scooters + rickshaws));

% Objective
solve minimize scooters;