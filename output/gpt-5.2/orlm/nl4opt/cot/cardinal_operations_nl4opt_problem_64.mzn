% Parameters (with values embedded)
int: capacity_old = 100;
int: capacity_new = 80;
int: pollution_old = 50;
int: pollution_new = 30;

int: min_bottles = 5000;
int: max_new_vans = 30;

% Upper bound for old vans: enough to meet demand even if only old vans are used
int: max_old_vans = (min_bottles + capacity_old - 1) div capacity_old;

% Variables
var 0..max_old_vans: old_vans;
var 0..max_new_vans: new_vans;

% Constraints
constraint capacity_old * old_vans + capacity_new * new_vans >= min_bottles;
constraint new_vans <= max_new_vans;

% Objective
var int: total_pollution = pollution_old * old_vans + pollution_new * new_vans;
solve minimize total_pollution;