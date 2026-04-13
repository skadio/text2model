% Parameters
% Unit costs for each shipment type
int: cost_x1 = 5;
int: cost_x2 = 6;
int: cost_x3 = 7;
int: cost_x4 = 8;

% Capacity limits
int: cap_12 = 1000;   % x1 + x2 <= 1000
int: cap_34 = 800;    % x3 + x4 <= 800

% Minimum difference / compliance requirements
int: min_diff_13 = 200;  % x1 - (1/2)x3 >= 200  -> 2*x1 - x3 >= 400
int: min_diff_42 = 150;  % (1/4)x4 - x2 >= 150 -> x4 - 4*x2 >= 600


% Variables
% Shipment quantities (whole numbers, non-negative; practical upper bounds from caps)
var 0..cap_12: x1;  % type 1 shipments
var 0..cap_12: x2;  % type 2 shipments
var 0..cap_34: x3;  % type 3 shipments
var 0..cap_34: x4;  % type 4 shipments

% Total cost to minimize (bounded using variable bounds)
var 0..(cost_x1*cap_12 + cost_x2*cap_12 + cost_x3*cap_34 + cost_x4*cap_34): total_cost;


% Constraints
% Capacity constraints (logistical limits)
constraint x1 + x2 <= cap_12;   % combined type 1 and 2 shipments limit
constraint x3 + x4 <= cap_34;   % combined type 3 and 4 shipments limit

% Minimum difference / compliance constraints (integer-linearized to avoid fractions)
constraint 2 * x1 - x3 >= 2 * min_diff_13;   % x1 - (1/2)x3 >= 200 -> 2*x1 - x3 >= 400
constraint x4 - 4 * x2 >= 4 * min_diff_42;   % (1/4)x4 - x2 >= 150 -> x4 - 4*x2 >= 600

% Total cost definition (linking variable to decision variables)
constraint total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3 + cost_x4 * x4;


% Objective
solve minimize total_cost;