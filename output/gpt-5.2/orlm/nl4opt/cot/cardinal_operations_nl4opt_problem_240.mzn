% Parameters (with values embedded)
int: nEquipTypes = 2;
set of int: T = 1..nEquipTypes;

% Type indices: 1 = chop saw, 2 = steel cutter
array[T] of int: steel_per_day = [25, 5];
array[T] of int: waste_per_day = [25, 3];

int: required_steel = 520;
int: max_waste = 400;

% Upper bounds (safe finite bounds)
int: max_units_chop = ceil(required_steel div steel_per_day[1]) + 100; % safe upper bound
int: max_units_cutter = ceil(required_steel div steel_per_day[2]) + 100; % safe upper bound

% Variables
var 0..max_units_chop: x_chop;      % number of chop saws
var 0..max_units_cutter: x_cutter;  % number of steel cutters
var 0..(max_units_chop + max_units_cutter): total_units;

% Constraints
constraint total_units = x_chop + x_cutter;

% Meet steel cutting requirement
constraint steel_per_day[1] * x_chop + steel_per_day[2] * x_cutter >= required_steel;

% Waste limitation
constraint waste_per_day[1] * x_chop + waste_per_day[2] * x_cutter <= max_waste;

% Objective
solve minimize total_units;