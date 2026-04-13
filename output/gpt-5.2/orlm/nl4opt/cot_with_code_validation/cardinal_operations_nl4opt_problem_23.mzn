% Parameters
int: van_capacity = 6;
int: van_pollution = 7;
int: minibus_capacity = 10;
int: minibus_pollution = 10;

int: min_kids = 150;
int: max_minibuses = 10;

% Variables
var 0..max_minibuses: minibuses;
% vans must exceed minibuses; also need enough capacity for min_kids
var 0..((min_kids + van_capacity - 1) div van_capacity + max_minibuses): vans;

var 0..(van_pollution * ((min_kids + van_capacity - 1) div van_capacity + max_minibuses)
      + minibus_pollution * max_minibuses): total_pollution;

% Constraints
constraint vans > minibuses;

constraint van_capacity * vans + minibus_capacity * minibuses >= min_kids;

constraint total_pollution = van_pollution * vans + minibus_pollution * minibuses;

% Objective
solve minimize total_pollution;