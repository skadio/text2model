% Parameters
int: a1 = 5;
int: b1 = 4;
int: a2 = 3;
int: b2 = 6;
int: a3 = 8;
int: b3 = 7;

int: A_avail = 1000;
int: B_avail = 800;

int: demand_rhs = 100;

int: c1 = 10;
int: c2 = 15;
int: c3 = 20;

int: x1_max = 300;
int: x2_max = 200;
int: x3_max = 150;

% Variables
var 0..x1_max: x1;
var 0..x2_max: x2;
var 0..x3_max: x3;

var 0..(c1*x1_max + c2*x2_max + c3*x3_max): total_cost;

% Constraints
constraint a1*x1 + a2*x2 + a3*x3 <= A_avail;
constraint b1*x1 + b2*x2 + b3*x3 <= B_avail;

constraint x1 - 2*x2 + x3 >= demand_rhs;

constraint total_cost = c1*x1 + c2*x2 + c3*x3;

% Objective
solve minimize total_cost;