% Parameters
% Unit costs for each shipment type
int: cost_x1 = 5;
int: cost_x2 = 6;
int: cost_x3 = 7;
int: cost_x4 = 8;

% Capacity limits
int: cap_x1_x2 = 1000;   % x1 + x2 <= 1000
int: cap_x3_x4 = 800;    % x3 + x4 <= 800

% Minimum difference/requirement thresholds
int: req_x1_minus_half_x3 = 200;    % x1 - 0.5*x3 >= 200
int: req_quarter_x4_minus_x2 = 150; % 0.25*x4 - x2 >= 150


% Variables
var 0..cap_x1_x2: x1;   % number of shipments of type 1 (nonnegative integer)
var 0..cap_x1_x2: x2;   % number of shipments of type 2 (nonnegative integer)
var 0..cap_x3_x4: x3;   % number of shipments of type 3 (nonnegative integer)
var 0..cap_x3_x4: x4;   % number of shipments of type 4 (nonnegative integer)

% Total cost to minimize
var int: total_cost;


% Constraints
% Capacity constraints (logistical limits)
constraint x1 + x2 <= cap_x1_x2;
constraint x3 + x4 <= cap_x3_x4;

% Requirement constraints (avoid fractional coefficients by multiplying through)
% x1 - 0.5*x3 >= 200  <=>  2*x1 - x3 >= 400
constraint 2 * x1 - x3 >= 2 * req_x1_minus_half_x3;

% 0.25*x4 - x2 >= 150  <=>  x4 - 4*x2 >= 600
constraint x4 - 4 * x2 >= 4 * req_quarter_x4_minus_x2;

% Total cost definition
constraint total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3 + cost_x4 * x4;


% Objective
solve minimize total_cost;