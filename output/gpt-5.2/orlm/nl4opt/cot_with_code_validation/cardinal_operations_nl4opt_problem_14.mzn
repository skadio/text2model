% Parameters
int: scooter_capacity = 2;
int: rickshaw_capacity = 3;
int: min_visitors = 300;
float: max_rickshaw_fraction = 0.40;

% Variables
var 0..min_visitors: scooters;
var 0..min_visitors: rickshaws;

% Constraints
constraint scooter_capacity * scooters + rickshaw_capacity * rickshaws >= min_visitors;
constraint rickshaws * 100 <= 40 * (scooters + rickshaws);

% Objective
solve minimize scooters;