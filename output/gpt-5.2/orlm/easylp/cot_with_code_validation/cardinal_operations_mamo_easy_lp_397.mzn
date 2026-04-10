% Parameters
int: c1 = 5;
int: c2 = 7;
int: c3 = 3;
int: c4 = 4;

int: rhs1 = 50;
int: rhs2 = 30;
int: rhs3 = 20;
int: rhs4 = 10;

% Coefficients represented as integers by multiplying all constraints by 20 (LCM of 2,4,5,10)
% Constraint 1: 2*x1 + x2 - 0.5*x3 <= 50  -> 40*x1 + 20*x2 - 10*x3 <= 1000
% Constraint 2: x1 + 2.5*x2 - x4 >= 30    -> 20*x1 + 50*x2 - 20*x4 >= 600
% Constraint 3: -0.75*x1 + x3 + x4 <= 20  -> -15*x1 + 20*x3 + 20*x4 <= 400
% Constraint 4: -x1 - x2 + 0.6*x4 >= 10   -> -20*x1 - 20*x2 + 12*x4 >= 200

int: M = 1000; % generic upper bound for allocations (since specific maximums not provided)

% Variables
var 0..M: x1;
var 0..M: x2;
var 0..M: x3;
var 0..M: x4;

var 0..(c1*M + c2*M + c3*M + c4*M): total_cost;

% Constraints
constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

constraint 40*x1 + 20*x2 - 10*x3 <= 20*rhs1;
constraint 20*x1 + 50*x2 - 20*x4 >= 20*rhs2;
constraint -15*x1 + 20*x3 + 20*x4 <= 20*rhs3;
constraint -20*x1 - 20*x2 + 12*x4 >= 20*rhs4;

% Objective
solve minimize total_cost;