% Parameters
int: c1 = 50;
int: c2 = 60;
int: c3 = 30;
int: c4 = 40;

int: x1_lb = 0;    int: x1_ub = 3000;
int: x2_lb = 0;    int: x2_ub = 2500;
int: x3_lb = 0;    int: x3_ub = 1500;
int: x4_lb = 0;    int: x4_ub = 1200;

int: cap12 = 5000;
int: cap34 = 2000;

int: diff12_min = 1000;
int: diff34_max = 500;

% Variables
var x1_lb..x1_ub: x1;
var x2_lb..x2_ub: x2;
var x3_lb..x3_ub: x3;
var x4_lb..x4_ub: x4;

var 0..(c1*x1_ub + c2*x2_ub + c3*x3_ub + c4*x4_ub): total_cost;

% Constraints
constraint x1 + x2 <= cap12;
constraint x3 + x4 <= cap34;

constraint x1 - x2 >= diff12_min;
constraint abs(x3 - x4) <= diff34_max;

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;