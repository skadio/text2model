% Parameters
int: total_bw = 10000;
int: rhs1 = 3000;        % x - 0.5y >= 3000
int: rhs2 = 2000;        % y - 0.75x <= 2000
int: cost_x = 20;
int: cost_y = 30;

% Variables
var 0..total_bw: x;
var 0..total_bw: y;
var 0..(cost_x*total_bw + cost_y*total_bw): total_cost;

% Constraints
constraint x + y <= total_bw;

% Multiply to avoid fractions:
% x - 0.5y >= 3000  <=>  2x - y >= 6000
constraint 2*x - y >= 2*rhs1;

% y - 0.75x <= 2000  <=>  4y - 3x <= 8000
constraint 4*y - 3*x <= 4*rhs2;

constraint total_cost = cost_x*x + cost_y*y;

% Objective
solve minimize total_cost;