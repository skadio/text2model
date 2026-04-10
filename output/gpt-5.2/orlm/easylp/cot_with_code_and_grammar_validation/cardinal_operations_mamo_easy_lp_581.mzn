% Parameters
int: cost1 = 500;
int: cost2 = 300;
int: cost3 = 400;

int: total_cap = 200;

int: x1_lb = 10; int: x1_ub = 100;
int: x2_lb = 20; int: x2_ub = 150;
int: x3_lb = 15; int: x3_ub = 120;

% ROI: 0.5*x1 - 0.3*x2 + 0.4*x3 >= 50
% Multiply by 10 to avoid decimals: 5*x1 - 3*x2 + 4*x3 >= 500
int: roi_rhs = 500;

% Risk: 0.2*x1 + 0.6*x2 - 0.8*x3 <= 30
% Multiply by 10 to avoid decimals: 2*x1 + 6*x2 - 8*x3 <= 300
int: risk_rhs = 300;

% Variables
var x1_lb..x1_ub: x1;
var x2_lb..x2_ub: x2;
var x3_lb..x3_ub: x3;

var 0..(cost1*x1_ub + cost2*x2_ub + cost3*x3_ub): total_cost;

% Constraints
constraint x1 + x2 + x3 <= total_cap;

constraint 5*x1 - 3*x2 + 4*x3 >= roi_rhs;

constraint 2*x1 + 6*x2 - 8*x3 <= risk_rhs;

constraint total_cost = cost1*x1 + cost2*x2 + cost3*x3;

% Objective
solve minimize total_cost;