% Parameters (with values embedded)
int: van_capacity = 50;
int: truck_capacity = 100;
int: min_pairs = 2000;

% Variables
var 0..(min_pairs div van_capacity): vans;
var 0..(min_pairs div truck_capacity): trucks;

% Constraints
constraint van_capacity * vans + truck_capacity * trucks >= min_pairs;
constraint trucks <= vans;

% Objective
solve minimize vans;