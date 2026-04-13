% Parameters
int: capacity_total = 1000;
int: demand_units = 1500;
int: diff_xy = 200;
int: cost_x = 50;
int: cost_y = 70;

% Variables
var 0..capacity_total: x; % shipments on Route X
var 0..capacity_total: y; % shipments on Route Y
var 0..(cost_x*capacity_total + cost_y*capacity_total): total_cost;

% Constraints
constraint x + y <= capacity_total;
constraint 2*x + 3*y >= demand_units;
constraint x - y >= diff_xy;

constraint total_cost = cost_x*x + cost_y*y;

% Objective
solve minimize total_cost;