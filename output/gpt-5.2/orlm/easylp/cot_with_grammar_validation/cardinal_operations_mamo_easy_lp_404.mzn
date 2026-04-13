% Parameters
int: cost_x1 = 4;
int: cost_x2 = 3;
int: cost_x3 = 5;
int: cost_x4 = 7;

int: ub_x1 = 700;
int: ub_x2 = 600;
int: ub_x3 = 400;
int: ub_x4 = 500;

int: cap_12 = 1000;
int: cap_34 = 800;

int: dem_13 = 500;
int: dem_24 = 600;

% Variables
var 0..ub_x1: x1;
var 0..ub_x2: x2;
var 0..ub_x3: x3;
var 0..ub_x4: x4;

var 0..(cost_x1*ub_x1 + cost_x2*ub_x2 + cost_x3*ub_x3 + cost_x4*ub_x4): total_cost;

% Constraints
constraint x1 + x2 <= cap_12;
constraint x3 + x4 <= cap_34;

constraint x1 + x3 >= dem_13;
constraint x2 + x4 >= dem_24;

constraint total_cost = cost_x1*x1 + cost_x2*x2 + cost_x3*x3 + cost_x4*x4;

% Objective
solve minimize total_cost;