% Parameters
int: van_capacity = 6;
int: van_pollution = 7;
int: minibus_capacity = 10;
int: minibus_pollution = 10;

int: kids_min = 150;
int: minibuses_max = 10;

% Variables
int: van_max = ceil(int2float(kids_min) / int2float(van_capacity)) + minibuses_max * ceil(int2float(minibus_capacity) / int2float(van_capacity));
var 0..van_max: vans;
var 0..minibuses_max: minibuses;

var 0..(van_pollution * van_max + minibus_pollution * minibuses_max): total_pollution;

% Constraints
constraint van_capacity * vans + minibus_capacity * minibuses >= kids_min;

constraint minibuses <= minibuses_max;

constraint vans > minibuses;

constraint total_pollution = van_pollution * vans + minibus_pollution * minibuses;

% Objective
solve minimize total_pollution;