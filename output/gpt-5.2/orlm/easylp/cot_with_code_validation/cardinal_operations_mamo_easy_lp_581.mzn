% Parameters
int: cost_x1 = 500;
int: cost_x2 = 300;
int: cost_x3 = 400;

int: total_max = 200;

float: roi_a1 = 0.5;
float: roi_a2 = -0.3;
float: roi_a3 = 0.4;
float: roi_min = 50.0;

float: risk_b1 = 0.2;
float: risk_b2 = 0.6;
float: risk_b3 = -0.8;
float: risk_max = 30.0;

int: x1_lb = 10;
int: x1_ub = 100;
int: x2_lb = 20;
int: x2_ub = 150;
int: x3_lb = 15;
int: x3_ub = 120;

% Variables
var x1_lb..x1_ub: x1;
var x2_lb..x2_ub: x2;
var x3_lb..x3_ub: x3;

var 0..(cost_x1*x1_ub + cost_x2*x2_ub + cost_x3*x3_ub): total_cost;

% Constraints
constraint x1 + x2 + x3 <= total_max;

constraint roi_a1*int2float(x1) + roi_a2*int2float(x2) + roi_a3*int2float(x3) >= roi_min;

constraint risk_b1*int2float(x1) + risk_b2*int2float(x2) + risk_b3*int2float(x3) <= risk_max;

constraint total_cost = cost_x1*x1 + cost_x2*x2 + cost_x3*x3;

% Objective
solve minimize total_cost;