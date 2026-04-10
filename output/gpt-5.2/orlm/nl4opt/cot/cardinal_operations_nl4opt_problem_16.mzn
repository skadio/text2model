% Parameters (with values embedded)
int: min_chlorine = 200;
int: total_chemicals = 500;

int: time_per_unit_chlorine = 1;   % minutes per unit
int: time_per_unit_softener = 2;   % minutes per unit

% chlorine must be at most half as much as water softener: C <= 0.5 * S  <=>  2C <= S
% Variables
var 0..total_chemicals: chlorine;
var 0..total_chemicals: softener;
var 0..1000000: total_time;

% Constraints
constraint chlorine + softener = total_chemicals;
constraint chlorine >= min_chlorine;
constraint 2 * chlorine <= softener;

% Note: "chlorine must be added before water softener or vice versa" means sequential,
% so total time is the sum of times.
constraint total_time = time_per_unit_chlorine * chlorine + time_per_unit_softener * softener;

% Objective
solve minimize total_time;