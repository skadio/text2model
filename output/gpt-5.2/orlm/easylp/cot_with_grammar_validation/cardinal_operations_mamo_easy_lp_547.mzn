% Parameters
int: cost_x1 = 2;
int: cost_x2 = 3;
int: cost_x3 = 4;

int: max_total = 1000;

int: ub_x1 = 599; % x1 < 600
int: ub_x2 = 500; % x2 <= 500
int: ub_x3 = 299; % x3 < 300

% Variables
var 0..ub_x1: x1;
var 0..ub_x2: x2;
var 0..ub_x3: x3;

var 0..(cost_x1*ub_x1 + cost_x2*ub_x2 + cost_x3*ub_x3): total_cost;

% Constraints
constraint x1 + x2 + x3 <= max_total;

% Use integer-scaled constraints to avoid fractions:
% 5*x1 - 0.5*x2 >= 500  <=>  10*x1 - x2 >= 1000
constraint 10*x1 - x2 >= 1000;

% 4.5*x3 - x1 <= 450  <=>  9*x3 - 2*x1 <= 900
constraint 9*x3 - 2*x1 <= 900;

% x2 + 0.5*x3 - x1 >= 200  <=>  2*x2 + x3 - 2*x1 >= 400
constraint 2*x2 + x3 - 2*x1 >= 400;

constraint total_cost = cost_x1*x1 + cost_x2*x2 + cost_x3*x3;

% Objective
solve minimize total_cost;