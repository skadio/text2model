% Parameters
int: reg_capacity = 500;
int: hyb_capacity = 300;
int: reg_pollution = 200;
int: hyb_pollution = 100;

int: max_pollution = 7000;
int: min_packages = 20000;

% Variables
var 0..max_pollution div reg_pollution: reg_vans;
var 0..max_pollution div hyb_pollution: hyb_vans;

% Constraints
constraint reg_pollution * reg_vans + hyb_pollution * hyb_vans <= max_pollution;
constraint reg_capacity * reg_vans + hyb_capacity * hyb_vans >= min_packages;

% Objective
solve minimize reg_vans + hyb_vans;