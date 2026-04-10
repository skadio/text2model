% Parameters
int: c1 = 2;
int: c2 = 3;
int: c3 = 4;
int: c4 = 5;

int: cap12 = 1000;
int: cap34 = 800;

int: ub1 = 500;
int: ub2 = 600;
int: ub3 = 400;
int: ub4 = 300;

% To avoid fractional coefficients, scale constraints by 10:
% 0.5*x1 - 0.6*x2 >= 50  =>  5*x1 - 6*x2 >= 500
int: rhs_a = 500;

% 0.7*x3 - x4 <= 70  =>  7*x3 - 10*x4 <= 700
int: rhs_b = 700;

% Variables
var 0..ub1: x1;
var 0..ub2: x2;
var 0..ub3: x3;
var 0..ub4: x4;

var 0..(c1*ub1 + c2*ub2 + c3*ub3 + c4*ub4): total_cost;

% Constraints
constraint x1 + x2 <= cap12;
constraint x3 + x4 <= cap34;

constraint 5*x1 - 6*x2 >= rhs_a;
constraint 7*x3 - 10*x4 <= rhs_b;

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;