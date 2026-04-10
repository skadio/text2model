% Parameters (with values embedded)
int: max_total_properties = 50;
int: cost_residential = 10000;
int: cost_commercial  = 15000;
int: cost_industrial  = 20000;

int: max_residential = 20;
int: max_commercial  = 15;
int: max_industrial  = 25;

int: min_res_plus_com = 30;
int: max_com_plus_ind = 40;

% Variables
var 0..max_residential: X; % residential
var 0..max_commercial:  Y; % commercial
var 0..max_industrial:  Z; % industrial

var 0..(cost_residential*max_residential + cost_commercial*max_commercial + cost_industrial*max_industrial): total_cost;

% Constraints
constraint X + Y + Z <= max_total_properties;
constraint X >= 2 * Y;
constraint X + Y >= min_res_plus_com;
constraint Y + Z <= max_com_plus_ind;

constraint total_cost = cost_residential * X + cost_commercial * Y + cost_industrial * Z;

% Objective
solve minimize total_cost;