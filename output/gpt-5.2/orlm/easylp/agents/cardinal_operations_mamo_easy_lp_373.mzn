% Parameters
% Unit costs for each warehouse allocation variable (embedded from description)
int: cost_x1 = 10;
int: cost_x2 = 15;
int: cost_x3 = 20;
int: cost_x4 = 25;

% Capacity / demand limits (embedded from description)
int: cap_12 = 500;     % x1 + x2 <= 500
int: cap_34 = 400;     % x3 + x4 <= 400
int: min_13 = 350;     % x1 + x3 >= 350
int: min_24 = 300;     % x2 + x4 >= 300

% Variables
var 0..cap_12: x1;     % resources allocated to warehouse 1 (nonnegative integer)
var 0..cap_12: x2;     % resources allocated to warehouse 2 (nonnegative integer)
var 0..cap_34: x3;     % resources allocated to warehouse 3 (nonnegative integer)
var 0..cap_34: x4;     % resources allocated to warehouse 4 (nonnegative integer)

var int: total_cost;   % objective value (total allocation cost)

% Constraints
%--- Capacity constraints (pairwise maximums)
constraint x1 + x2 <= cap_12;  % Combined allocation to warehouses 1 and 2 cannot exceed cap_12
constraint x3 + x4 <= cap_34;  % Combined allocation to warehouses 3 and 4 cannot exceed cap_34

%--- Demand constraints (pairwise minimums)
constraint x1 + x3 >= min_13;  % Warehouses 1 and 3 must meet at least min_13 total allocation
constraint x2 + x4 >= min_24;  % Warehouses 2 and 4 must meet at least min_24 total allocation

%--- Total cost definition (linking cost variable to decision variables)
constraint total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3 + cost_x4 * x4;

% Objective
solve minimize total_cost;