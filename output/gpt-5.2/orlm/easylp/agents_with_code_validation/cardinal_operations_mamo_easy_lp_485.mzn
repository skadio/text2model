% Parameters
% Budget/resource limit (units)
int: max_total_resources = 100;

% Minimum required combined impact
int: min_impact = 300;

% Impact coefficients for initiatives X and Y
int: impact_x = 3;
int: impact_y = 4;

% Maximum allowed absolute difference between allocations
int: max_diff = 20;

% Unit costs (dollars per unit) for X and Y
int: cost_x = 5;
int: cost_y = 2;


% Variables
% Resource allocation (indivisible whole units)
var 0..max_total_resources: x; % units allocated to initiative X
var 0..max_total_resources: y; % units allocated to initiative Y

% Total cost (integer dollars)
var 0..(cost_x * max_total_resources + cost_y * max_total_resources): total_cost;


% Constraints
% --- Budget/resource limit ---
% Total allocated resources cannot exceed the available budget (in units)
constraint x + y <= max_total_resources;

% --- Mission impact requirement ---
% Combined impact must meet or exceed the minimum required impact
constraint impact_x * x + impact_y * y >= min_impact;

% --- Balance requirement between initiatives ---
% Allocations must remain within the maximum allowed absolute difference
constraint abs(x - y) <= max_diff;

% --- Total cost definition ---
% Total cost equals the sum of per-unit costs times allocated units
constraint total_cost = cost_x * x + cost_y * y;


% Objective
solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "total_cost = ", show(total_cost), "\n"
];