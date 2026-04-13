% Parameters (with values embedded)
int: van_capacity = 6;
int: van_pollution = 7;
int: minibus_capacity = 10;
int: minibus_pollution = 10;

int: min_kids = 150;
int: max_minibuses = 10;

% Variables
var 0..1000: vans;
var 0..max_minibuses: minibuses;

% Constraints
constraint van_capacity * vans + minibus_capacity * minibuses >= min_kids;
constraint vans > minibuses;

% Objective
var 0..100000: total_pollution;
constraint total_pollution = van_pollution * vans + minibus_pollution * minibuses;

solve minimize total_pollution;