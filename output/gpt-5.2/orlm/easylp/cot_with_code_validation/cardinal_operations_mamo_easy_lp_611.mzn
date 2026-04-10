% Parameters
int: max_wc = 500;
int: max_rb = 600;

int: min_w_minus_r = 100;
int: min_c_minus_b = 200;

int: cost_w = 10;
int: cost_c = 20;
int: cost_r = 30;
int: cost_b = 40;

% Variables
var 0..max_wc: W;          % Wheat acres
var 0..max_wc: C;          % Corn acres
var 0..max_rb: R;          % Rice acres
var 0..max_rb: B;          % Barley acres

var 0..(cost_w*max_wc + cost_c*max_wc + cost_r*max_rb + cost_b*max_rb): TotalCost;

% Constraints
constraint W + C <= max_wc;
constraint R + B <= max_rb;

constraint W - R >= min_w_minus_r;
constraint C - B >= min_c_minus_b;

constraint TotalCost = cost_w*W + cost_c*C + cost_r*R + cost_b*B;

% Objective
solve minimize TotalCost;