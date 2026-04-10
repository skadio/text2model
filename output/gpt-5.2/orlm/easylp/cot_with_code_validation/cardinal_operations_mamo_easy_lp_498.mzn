% Parameters
int: max_residential = 15;
int: max_commercial = 10;
int: max_total = 20;

float: min_effort = 15.0;              % 2*x + 0.5*y >= 15
int: max_diff = 5;                     % |x - y| <= 5

int: cost_residential = 30000;
int: cost_commercial = 50000;

% Variables
var 0..max_residential: x;             % number of residential buildings
var 0..max_commercial: y;              % number of commercial buildings
var 0..(cost_residential*max_residential + cost_commercial*max_commercial): total_cost;

% Constraints
constraint x + y <= max_total;

constraint 2.0*int2float(x) + 0.5*int2float(y) >= min_effort;

constraint abs(x - y) <= max_diff;

constraint total_cost = cost_residential*x + cost_commercial*y;

% Objective
solve minimize total_cost;