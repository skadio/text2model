% Parameters
int: van_capacity = 6;
int: van_pollution = 7;
int: bus_capacity = 10;
int: bus_pollution = 10;

int: kids_min = 150;
int: bus_max = 10;

% Variables
var 0..kids_min: vans;
var 0..bus_max: buses;

% Constraints
constraint van_capacity * vans + bus_capacity * buses >= kids_min;
constraint buses <= bus_max;
constraint vans > buses;

% Objective
solve minimize van_pollution * vans + bus_pollution * buses;