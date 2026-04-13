% Parameters (with values embedded)
int: cost_residential = 50000;
int: cost_commercial  = 30000;
int: cost_industrial  = 70000;

int: max_total_properties = 10;

% Market availability bounds (embedded as explicit bounds)
int: max_residential = 10;
int: max_commercial  = 10;
int: max_industrial  = 10;

% Variables
var 0..max_residential: x; % residential
var 0..max_commercial:  y; % commercial
var 0..max_industrial:  z; % industrial

var 0..(cost_residential*max_residential + cost_commercial*max_commercial + cost_industrial*max_industrial): total_cost;

% Constraints
constraint x + y + z <= max_total_properties;

% Residential at least two more than commercial
constraint x >= y + 2;

% Difference between industrial and residential does not exceed 3
constraint abs(z - x) <= 3;

% Total cost definition
constraint total_cost = cost_residential*x + cost_commercial*y + cost_industrial*z;

% Objective
solve minimize total_cost;