% Parameters
int: cost_res = 300;
int: cost_com = 200;
int: cost_ind = 500;

int: max_units = 50;

int: roi_res = 5;
int: roi_com = 3;
int: roi_ind = 10;
int: min_roi = 100;

% Variables
var 0..max_units: x; % residential units
var 0..max_units: y; % commercial units
var 0..max_units: z; % industrial units

var 0..(cost_res*max_units + cost_com*max_units + cost_ind*max_units): total_cost;

% Constraints
constraint x + y + z <= max_units;

constraint roi_res*x + roi_com*y + roi_ind*z >= min_roi;

constraint x - y >= 0;

constraint total_cost = cost_res*x + cost_com*y + cost_ind*z;

% Objective
solve minimize total_cost;