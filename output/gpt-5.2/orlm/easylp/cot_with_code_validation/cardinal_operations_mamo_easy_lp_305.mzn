% Parameters
int: total_resource_limit = 5000;
int: effectiveness_min = 3000;
int: logistics_limit = 2500;

int: c1 = 5;
int: c2 = 3;
int: c3 = 7;

int: w_eff_1 = 4;
int: w_eff_3 = 6;

int: w_log_2 = 2;
int: w_log_3 = 3; % corresponds to "thrice the half resources for X3" => (3/2)*X3

% Variables
var 0..total_resource_limit: x1;
var 0..total_resource_limit: x2;
var 0..total_resource_limit: x3;

var 0..(c1*total_resource_limit + c2*total_resource_limit + c3*total_resource_limit): total_cost;

% Constraints
constraint x1 + x2 + x3 <= total_resource_limit;

constraint w_eff_1 * x1 + w_eff_3 * x3 >= effectiveness_min;

% 2*x2 + 3*(x3/2) <= 2500  <=>  4*x2 + 3*x3 <= 5000
constraint 4 * x2 + w_log_3 * x3 <= 2 * logistics_limit;

constraint total_cost = c1 * x1 + c2 * x2 + c3 * x3;

% Objective
solve minimize total_cost;