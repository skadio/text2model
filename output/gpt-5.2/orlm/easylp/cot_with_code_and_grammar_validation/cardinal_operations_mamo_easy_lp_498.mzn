% Parameters
int: max_residential = 15;
int: max_commercial = 10;
int: max_total = 20;

int: min_effort = 15;

float: effort_residential = 2.0;
float: effort_commercial = 0.5;

int: max_diff = 5;

int: cost_residential = 30000;
int: cost_commercial = 50000;

% Variables
var 0..max_residential: x; % residential buildings
var 0..max_commercial: y;  % commercial buildings

var 0..(cost_residential*max_residential + cost_commercial*max_commercial): total_cost;

% Constraints
constraint x + y <= max_total;

constraint effort_residential * int2float(x) + effort_commercial * int2float(y) >= int2float(min_effort);

constraint abs(x - y) <= max_diff;

constraint total_cost = cost_residential * x + cost_commercial * y;

% Objective
solve minimize total_cost;