% Parameters
int: total_bandwidth = 10000;
int: cost_x = 20;
int: cost_y = 30;

% Constraints (scaled to avoid fractions)
% x - 0.5y >= 3000  <=>  2x - y >= 6000
int: lhs1_const = 6000;

% y - 0.75x <= 2000  <=>  4y - 3x <= 8000
int: rhs2_const = 8000;

% Variables
var 0..total_bandwidth: x;
var 0..total_bandwidth: y;
var 0..(cost_x*total_bandwidth + cost_y*total_bandwidth): total_cost;

% Constraints
constraint x + y <= total_bandwidth;
constraint 2*x - y >= lhs1_const;
constraint 4*y - 3*x <= rhs2_const;

constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;