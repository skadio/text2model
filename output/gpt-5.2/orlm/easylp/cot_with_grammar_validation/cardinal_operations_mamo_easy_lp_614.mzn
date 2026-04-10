% Parameters
int: cost1 = 100;
int: cost2 = 200;
int: cost3 = 300;
int: cost4 = 400;

int: limit_x1_x2 = 30;
int: rhs_milestone = 40;
int: diff_x4_x2 = 20;
int: min_quality = 10;

% Variables
var 0..1000: x1;
var 0..1000: x2;
var 0..1000: x3;
var 0..1000: x4;

var 0..4000000: total_cost;

% Constraints
constraint x1 + x2 <= limit_x1_x2;
constraint 2 * x1 + x3 >= rhs_milestone;
constraint x4 - x2 = diff_x4_x2;

% Avoid fractional coefficient by multiplying by 2:
% x1 + 0.5*x3 >= 10  <=>  2*x1 + x3 >= 20
constraint 2 * x1 + x3 >= 2 * min_quality;

constraint total_cost = cost1 * x1 + cost2 * x2 + cost3 * x3 + cost4 * x4;

% Objective
solve minimize total_cost;