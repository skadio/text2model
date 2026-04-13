% Parameters
% Property costs (in dollars)
int: cost_residential = 50000;
int: cost_commercial  = 30000;
int: cost_industrial  = 70000;

% Maximum total number of properties allowed
int: max_total_properties = 10;

% Difference limit between industrial and residential properties
int: max_industrial_residential_diff = 3;

% Market availability bounds (use 0..max_total_properties)
int: min_residential = 0;
int: min_commercial  = 0;
int: min_industrial  = 0;

int: max_residential = max_total_properties;
int: max_commercial  = max_total_properties;
int: max_industrial  = max_total_properties;

% Variables
% Number of residential properties
var min_residential..max_residential: x;

% Number of commercial properties
var min_commercial..max_commercial: y;

% Number of industrial properties
var min_industrial..max_industrial: z;

% Total cost (in dollars)
var 0..(max_total_properties * max([cost_residential, cost_commercial, cost_industrial])): total_cost;

% Constraints
% --- Total number of properties constraint (portfolio size cap) ---
constraint x + y + z <= max_total_properties;

% --- Residential vs Commercial relationship (residential at least two more) ---
constraint x >= y + 2;

% --- Industrial vs Residential exposure constraint (difference not exceed limit) ---
constraint abs(z - x) <= max_industrial_residential_diff;

% --- Total cost definition constraint ---
constraint
  total_cost = cost_residential * x
             + cost_commercial  * y
             + cost_industrial  * z;

% Objective
solve minimize total_cost;