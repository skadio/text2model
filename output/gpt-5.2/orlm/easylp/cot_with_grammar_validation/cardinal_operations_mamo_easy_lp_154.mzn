% Parameters
int: max_total_shipments = 1000;
int: min_transport_units = 1500; % 2*X + 3*Y >= 1500
int: min_x_minus_y = 200;

int: cost_x = 50;
int: cost_y = 70;

% Variables
var 0..max_total_shipments: x; % shipments on Route X
var 0..max_total_shipments: y; % shipments on Route Y
var 0..(cost_x*max_total_shipments + cost_y*max_total_shipments): total_cost;

% Constraints
constraint x + y <= max_total_shipments;

constraint 2*x + 3*y >= min_transport_units;

constraint x - y >= min_x_minus_y;

constraint total_cost = cost_x*x + cost_y*y;

% Objective
solve minimize total_cost;