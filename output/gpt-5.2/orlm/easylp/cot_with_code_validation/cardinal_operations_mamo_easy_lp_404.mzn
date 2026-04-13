% Parameters
int: cost_x1 = 4;
int: cost_x2 = 3;
int: cost_x3 = 5;
int: cost_x4 = 7;

int: cap12 = 1000;
int: cap34 = 800;
int: min13 = 500;
int: min24 = 600;

int: lb_x1 = 0;   int: ub_x1 = 700;
int: lb_x2 = 0;   int: ub_x2 = 600;
int: lb_x3 = 0;   int: ub_x3 = 400;
int: lb_x4 = 0;   int: ub_x4 = 500;

% Variables
var lb_x1..ub_x1: x1;
var lb_x2..ub_x2: x2;
var lb_x3..ub_x3: x3;
var lb_x4..ub_x4: x4;

var 0..(cost_x1*ub_x1 + cost_x2*ub_x2 + cost_x3*ub_x3 + cost_x4*ub_x4): total_cost;

% Constraints
constraint x1 + x2 <= cap12;
constraint x3 + x4 <= cap34;

constraint x1 + x3 >= min13;
constraint x2 + x4 >= min24;

constraint total_cost = cost_x1*x1 + cost_x2*x2 + cost_x3*x3 + cost_x4*x4;

% Objective
solve minimize total_cost;