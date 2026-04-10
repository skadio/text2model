% Parameters
int: cost_residential = 50000;   % Cost per residential property
int: cost_commercial  = 30000;   % Cost per commercial property
int: cost_industrial  = 70000;   % Cost per industrial property

int: max_total_properties = 10;  % Cap on total number of properties
int: min_res_over_com = 2;       % Residential must be at least this many more than commercial
int: max_ind_res_diff = 3;       % |industrial - residential| must be at most this value

% Market availability bounds not specified; use a safe upper bound per type
int: max_per_type = max_total_properties;

% Variables
var 0..max_per_type: x; % Number of residential properties
var 0..max_per_type: y; % Number of commercial properties
var 0..max_per_type: z; % Number of industrial properties

% Total cost upper bound: max_total_properties * max unit cost
int: max_unit_cost = max(cost_residential, max(cost_commercial, cost_industrial));
var 0..(max_total_properties * max_unit_cost): total_cost;

% Constraints
% Link total_cost to the chosen numbers of properties and their unit costs
constraint
  total_cost = cost_residential * x
             + cost_commercial  * y
             + cost_industrial  * z;

% Portfolio size cap
constraint
  x + y + z <= max_total_properties;

% Residential at least min_res_over_com more than commercial
constraint
  x >= y + min_res_over_com;

% Industrial and residential differ by at most max_ind_res_diff
constraint
  abs(z - x) <= max_ind_res_diff;

% Objective
solve minimize total_cost;