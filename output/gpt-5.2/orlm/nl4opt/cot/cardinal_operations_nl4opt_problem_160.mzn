% Parameters (with values embedded)
int: toys_req = 250;
int: operators_avail = 16;

int: toys_medium = 50;
int: ops_medium  = 3;

int: toys_small = 35;
int: ops_small  = 2;

% Variables
var 0..(operators_avail div ops_medium): x_medium;
var 0..(operators_avail div ops_small):  x_small;

% Constraints
constraint toys_medium * x_medium + toys_small * x_small >= toys_req;
constraint ops_medium * x_medium + ops_small * x_small <= operators_avail;

% Objective
solve minimize x_medium + x_small;