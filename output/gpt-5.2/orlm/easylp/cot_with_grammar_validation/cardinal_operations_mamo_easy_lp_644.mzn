% Parameters
float: c1 = 0.5;
float: c2 = 0.3;
float: c3 = 0.4;
float: c4 = 0.6;

int: x1_min = 0;   int: x1_max = 400;
int: x2_min = 0;   int: x2_max = 300;
int: x3_min = 50;  int: x3_max = 200;
int: x4_min = 30;  int: x4_max = 60;

% Variables
var x1_min..x1_max: x1;
var x2_min..x2_max: x2;
var x3_min..x3_max: x3;
var x4_min..x4_max: x4;

var 0..1000000: scaled_cost; % cost * 10 to keep objective integer

% Constraints
constraint x1 + x2 <= 500;
constraint 2*x1 + 3*x3 >= 300;
constraint 2*x4 <= x2 + 200; % x4 <= 0.5*x2 + 100  -> 2*x4 <= x2 + 200
constraint (x2 + x4) - (x1 + x3) = 80;

% Scaled objective: 10*(0.5x1 + 0.3x2 + 0.4x3 + 0.6x4) = 5x1 + 3x2 + 4x3 + 6x4
constraint scaled_cost = 5*x1 + 3*x2 + 4*x3 + 6*x4;

% Objective
solve minimize scaled_cost;