% Parameters (with values embedded)
int: cost_residential = 300;
int: cost_commercial  = 200;
int: cost_industrial  = 500;

int: max_total_units = 50;

int: roi_residential = 5;
int: roi_commercial  = 3;
int: roi_industrial  = 10;
int: min_total_roi   = 100;

% Variables
var 0..max_total_units: x; % residential units
var 0..max_total_units: y; % commercial units
var 0..max_total_units: z; % industrial units

var 0..(cost_residential*max_total_units + cost_commercial*max_total_units + cost_industrial*max_total_units): total_cost;

% Constraints
constraint x + y + z <= max_total_units;
constraint roi_residential*x + roi_commercial*y + roi_industrial*z >= min_total_roi;
constraint x - y >= 0;

constraint total_cost = cost_residential*x + cost_commercial*y + cost_industrial*z;

% Objective
solve minimize total_cost;