% Parameters
int: steel_required = 520;
int: waste_max = 400;

int: steel_chop = 25;
int: waste_chop = 25;

int: steel_cutter = 5;
int: waste_cutter = 3;

% Upper bounds (safe, derived)
int: ub_chop = ceil(int2float(steel_required) / int2float(steel_chop));     % <= 21
int: ub_cutter = ceil(int2float(steel_required) / int2float(steel_cutter)); % <= 104

% Variables
var 0..ub_chop: x_chop;
var 0..ub_cutter: x_cutter;
var 0..(ub_chop + ub_cutter): total_machines;

% Constraints
constraint steel_chop * x_chop + steel_cutter * x_cutter >= steel_required;
constraint waste_chop * x_chop + waste_cutter * x_cutter <= waste_max;

constraint total_machines = x_chop + x_cutter;

% Objective
solve minimize total_machines;