% Parameters
int: c1 = 2;
int: c2 = 3;
int: c3 = 4;

int: cap12 = 1000;
int: cap23 = 1500;

int: diff13 = 300;
int: diff2  = 70;

% NOTE: The problem statement mentions "specific bounds" for x1,x2,x3 but does not provide them.
% We assume non-negativity as the only explicit bound.
int: L1 = 0;
int: L2 = 0;
int: L3 = 0;

int: U1 = 1000000;
int: U2 = 1000000;
int: U3 = 1000000;

% Variables
var L1..U1: x1;
var L2..U2: x2;
var L3..U3: x3;

var 0..(c1*U1 + c2*U2 + c3*U3): total_cost;

% Constraints
constraint x1 + 2*x2 <= cap12;
constraint 3*x1 >= x3 + diff13;
constraint 4*x2 + x3 <= cap23;
constraint 5*x2 - (x1 + x3) <= diff2;

constraint total_cost = c1*x1 + c2*x2 + c3*x3;

% Objective
solve minimize total_cost;