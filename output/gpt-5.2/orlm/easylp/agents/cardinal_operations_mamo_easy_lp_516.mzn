% Parameters
% Maximum total resources available across all routes
int: max_total_resources = 2000;

% Minimum difference constraints
int: min_diff_X_vs_2Y = 1000;   % X - 2*Y >= 1000
int: min_diff_Z_vs_Y  = 500;    % Z - Y   >= 500

% Unit costs for each route
int: cost_X = 3;
int: cost_Y = 2;
int: cost_Z = 1;


% Variables
% Integer resource allocations to each route (non-negative and bounded by max_total_resources)
var 0..max_total_resources: x;  % resources allocated to route X
var 0..max_total_resources: y;  % resources allocated to route Y
var 0..max_total_resources: z;  % resources allocated to route Z

% Total cost (bounded using max_total_resources and maximum unit cost)
var 0..(max_total_resources * max(cost_X, max(cost_Y, cost_Z))): total_cost;


% Constraints
%--- Total resource capacity constraint ---
constraint x + y + z <= max_total_resources;

%--- Minimum difference constraints between routes ---
% Route X must exceed twice route Y by at least min_diff_X_vs_2Y
constraint x - 2 * y >= min_diff_X_vs_2Y;

% Route Z must exceed route Y by at least min_diff_Z_vs_Y
constraint z - y >= min_diff_Z_vs_Y;

%--- Total cost definition constraint ---
constraint total_cost = cost_X * x + cost_Y * y + cost_Z * z;


% Objective
solve minimize total_cost;