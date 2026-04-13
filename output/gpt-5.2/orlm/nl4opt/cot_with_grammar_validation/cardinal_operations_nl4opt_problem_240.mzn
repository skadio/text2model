% Parameters
int: steel_required = 520;
int: waste_limit = 400;

int: steel_chop = 25;
int: waste_chop = 25;

int: steel_cutter = 5;
int: waste_cutter = 3;

% Variables
var 0..ceil(steel_required div steel_chop) + steel_required: x_chop;
var 0..steel_required: x_cutter;

% Constraints
constraint steel_chop * x_chop + steel_cutter * x_cutter >= steel_required;
constraint waste_chop * x_chop + waste_cutter * x_cutter <= waste_limit;

% Objective
solve minimize x_chop + x_cutter;