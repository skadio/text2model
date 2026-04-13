% Parameters
int: scooter_capacity = 2;
int: rickshaw_capacity = 3;
int: min_visitors = 300;
float: max_rickshaw_fraction = 0.4;

% Variables
var 0..ceil(int2float(min_visitors) / int2float(scooter_capacity)): scooters;
var 0..ceil(int2float(min_visitors) / int2float(rickshaw_capacity)): rickshaws;

% Constraints
constraint
  scooter_capacity * scooters + rickshaw_capacity * rickshaws >= min_visitors;

% At most 40% of vehicles used can be rickshaws:
% rickshaws <= 0.4 * (scooters + rickshaws)  ->  3*rickshaws <= 2*scooters
constraint
  3 * rickshaws <= 2 * scooters;

% Objective
solve minimize scooters;