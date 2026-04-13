% Parameters
int: c1 = 5;
int: c2 = 6;
int: c3 = 7;
int: c4 = 8;

int: cap12 = 1000;
int: cap34 = 800;

int: rhs13 = 200;   % x1 - 0.5*x3 >= 200  ->  2*x1 - x3 >= 400
int: rhs42 = 150;   % 0.25*x4 - x2 >= 150 ->  x4 - 4*x2 >= 600

% Variables
var 0..cap12: x1;
var 0..cap12: x2;
var 0..cap34: x3;
var 0..(4*cap12 + cap34): x4; % safe upper bound from x4 >= 4*x2 + 600 and x2<=1000 plus cap34

var 0..(c1*cap12 + c2*cap12 + c3*cap34 + c4*(4*cap12 + cap34)): total_cost;

% Constraints
constraint x1 + x2 <= cap12;
constraint x3 + x4 <= cap34;

constraint 2*x1 - x3 >= 2*rhs13;         % 2*x1 - x3 >= 400
constraint x4 - 4*x2 >= 4*rhs42;          % x4 - 4*x2 >= 600

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;