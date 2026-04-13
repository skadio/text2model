% Parameters
int: total_bw = 10000;
int: cost_x = 20;
int: cost_y = 30;

% To avoid fractions, scale constraints by 4:
% x - 0.5y >= 3000  ->  2x - y >= 6000  ->  4*(2x - y) >= 24000 -> 8x - 4y >= 24000
% y - 0.75x <= 2000 ->  4y - 3x <= 8000
int: rhs1 = 24000; % for 8x - 4y >= rhs1
int: rhs2 = 8000;  % for 4y - 3x <= rhs2

% Variables
var 0..total_bw: x;
var 0..total_bw: y;
var 0..(cost_x*total_bw + cost_y*total_bw): total_cost;

% Constraints
constraint x + y <= total_bw;

constraint 8*x - 4*y >= rhs1;
constraint 4*y - 3*x <= rhs2;

constraint total_cost = cost_x*x + cost_y*y;

% Objective
solve minimize total_cost;