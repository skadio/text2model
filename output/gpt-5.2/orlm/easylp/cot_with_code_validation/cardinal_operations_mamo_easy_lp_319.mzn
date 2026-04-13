% Parameters
int: capacity = 1000;
int: rhs_balance = 200;     % 2*X1 - 3*X2 >= 200
int: rhs_limit = 500;       % 4*X3 - X1 <= 500

int: c1 = 5;
int: c2 = 8;
int: c3 = 6;

% Variables
var 0..capacity: X1;
var 0..capacity: X2;
var 0..capacity: X3;

var 0..(c1*capacity + c2*capacity + c3*capacity): total_cost;

% Constraints
constraint X1 + X2 + X3 <= capacity;

constraint 2*X1 - 3*X2 >= rhs_balance;

constraint 4*X3 - X1 <= rhs_limit;

constraint total_cost = c1*X1 + c2*X2 + c3*X3;

% Objective
solve minimize total_cost;