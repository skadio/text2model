% Parameters
int: regular_capacity = 500;
int: hybrid_capacity  = 300;

int: regular_pollution = 200;
int: hybrid_pollution  = 100;

int: max_pollution = 7000;
int: min_packages  = 20000;

% Variables
var 0..ceil(int2float(min_packages) / int2float(regular_capacity)): regular_vans;
var 0..ceil(int2float(min_packages) / int2float(hybrid_capacity)):  hybrid_vans;
var 0..(ceil(int2float(min_packages) / int2float(regular_capacity)) +
        ceil(int2float(min_packages) / int2float(hybrid_capacity))): total_vans;

% Constraints
constraint total_vans = regular_vans + hybrid_vans;

constraint regular_capacity * regular_vans + hybrid_capacity * hybrid_vans >= min_packages;

constraint regular_pollution * regular_vans + hybrid_pollution * hybrid_vans <= max_pollution;

% Objective
solve minimize total_vans;