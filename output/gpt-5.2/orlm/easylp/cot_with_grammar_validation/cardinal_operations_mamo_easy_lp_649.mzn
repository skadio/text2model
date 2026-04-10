% Parameters
int: c1 = 5;
int: c2 = 6;
int: c3 = 7;
int: c4 = 8;

int: ub12 = 1000;
int: ub34 = 800;

int: rhs1 = 200; % x1 - 0.5*x3 >= 200  ->  2*x1 - x3 >= 400
int: rhs2 = 150; % 0.25*x4 - x2 >= 150 -> x4 - 4*x2 >= 600

% Variables
var 0..1000: x1;
var 0..1000: x2;
var 0..800:  x3;
var 0..800:  x4;

var 0..(c1*1000 + c2*1000 + c3*800 + c4*800): total_cost;

% Constraints
constraint x1 + x2 <= ub12;
constraint x3 + x4 <= ub34;

constraint 2*x1 - x3 >= 2*rhs1;   % 2*x1 - x3 >= 400
constraint x4 - 4*x2 >= 4*rhs2;   % x4 - 4*x2 >= 600

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;