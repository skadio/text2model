% Parameters
int: c1 = 5;
int: c2 = 7;
int: c3 = 3;
int: c4 = 8;

int: ub1 = 500;
int: ub2 = 400;
int: ub3 = 300;
int: ub4 = 200;

int: limit12 = 1500;
int: thresh13 = 1000;
int: limit42 = 600;
int: deficit = 200;

% Variables
var 0..ub1: x1;
var 0..ub2: x2;
var 0..ub3: x3;
var 0..ub4: x4;

var 0..(c1*ub1 + c2*ub2 + c3*ub3 + c4*ub4): total_cost;

% Constraints
constraint x1 + 2*x2 <= limit12;
constraint 3*x1 + x3 >= thresh13;
constraint 4*x4 - x2 <= limit42;
constraint -x1 + x2 + x3 + x4 = -deficit;

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;