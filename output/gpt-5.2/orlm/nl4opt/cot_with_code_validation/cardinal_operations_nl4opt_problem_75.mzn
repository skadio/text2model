% Parameters
int: van_capacity = 50;
int: truck_capacity = 100;
int: min_pairs = 2000;

% Variables
var 0..ceil(min_pairs / van_capacity): vans;
var 0..ceil(min_pairs / truck_capacity): trucks;

% Constraints
constraint van_capacity * vans + truck_capacity * trucks >= min_pairs;
constraint trucks <= vans;

% Objective
solve minimize vans;