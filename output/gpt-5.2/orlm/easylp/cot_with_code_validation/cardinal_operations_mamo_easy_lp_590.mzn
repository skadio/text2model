% Parameters
int: c1 = 10;
int: c2 = 15;
int: c3 = 20;
int: c4 = 25;

int: cap12 = 1000;
int: cap34 = 1500;

int: min_diff_2_13 = 300;   % x2 - (x1 + x3) >= 300
int: max_diff_3_24 = 500;   % x3 - (x2 + x4) <= 500

% Output bounds (not specified explicitly in the description; assume non-negative)
int: lb = 0;
int: ub = 1000000;

% Variables
var lb..ub: x1;
var lb..ub: x2;
var lb..ub: x3;
var lb..ub: x4;

var 0..(c1*ub + c2*ub + c3*ub + c4*ub): total_cost;

% Constraints
constraint x1 + x2 <= cap12;

constraint 2*x3 + 3*x4 <= cap34;

constraint x2 - (x1 + x3) >= min_diff_2_13;

constraint x3 - (x2 + x4) <= max_diff_3_24;

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;