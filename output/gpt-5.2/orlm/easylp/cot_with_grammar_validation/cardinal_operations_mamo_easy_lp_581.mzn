% Parameters
int: max_total_units = 200;

int: c1 = 500;
int: c2 = 300;
int: c3 = 400;

int: x1_min = 10;
int: x1_max = 100;
int: x2_min = 20;
int: x2_max = 150;
int: x3_min = 15;
int: x3_max = 120;

% ROI constraint (scaled by 10 to avoid decimals): 0.5*x1 - 0.3*x2 + 0.4*x3 >= 50
% => 5*x1 - 3*x2 + 4*x3 >= 500
int: roi_rhs = 500;

% Risk constraint (scaled by 10 to avoid decimals): 0.2*x1 + 0.6*x2 - 0.8*x3 <= 30
% => 2*x1 + 6*x2 - 8*x3 <= 300
int: risk_rhs = 300;

% Variables
var x1_min..x1_max: x1;
var x2_min..x2_max: x2;
var x3_min..x3_max: x3;

var 0..(c1*x1_max + c2*x2_max + c3*x3_max): total_cost;

% Constraints
constraint x1 + x2 + x3 <= max_total_units;

constraint 5*x1 - 3*x2 + 4*x3 >= roi_rhs;

constraint 2*x1 + 6*x2 - 8*x3 <= risk_rhs;

constraint total_cost = c1*x1 + c2*x2 + c3*x3;

% Objective
solve minimize total_cost;