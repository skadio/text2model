% Parameters (with values embedded)
int: cost_x1 = 2;
int: cost_x2 = 3;
int: cost_x3 = 4;

int: total_cap = 1000;

int: x1_ub = 599; % manufacturing < 600
int: x2_ub = 500; % distribution <= 500
int: x3_ub = 299; % retail < 300

% Variables
var 0..x1_ub: x1;
var 0..x2_ub: x2;
var 0..x3_ub: x3;

% Constraints
constraint x1 + x2 + x3 <= total_cap;

% Avoid fractional coefficients by multiplying by 2 where needed
% 5*x1 - 0.5*x2 >= 500  <=>  10*x1 - x2 >= 1000
constraint 10*x1 - x2 >= 1000;

% 4.5*x3 - x1 <= 450  <=>  9*x3 - 2*x1 <= 900
constraint 9*x3 - 2*x1 <= 900;

% x2 + 0.5*x3 - x1 >= 200  <=>  2*x2 + x3 - 2*x1 >= 400
constraint 2*x2 + x3 - 2*x1 >= 400;

% Objective
var int: total_cost = cost_x1*x1 + cost_x2*x2 + cost_x3*x3;

solve minimize total_cost;

output [
  "x1(manufacturing) = ", show(x1), "\n",
  "x2(distribution)  = ", show(x2), "\n",
  "x3(retail)        = ", show(x3), "\n",
  "minimum_cost      = ", show(total_cost), "\n"
];