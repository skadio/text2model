% Parameters
int: t1_A = 2;
int: t2_A = 3;
int: t1_B = 3;
int: t2_B = 4;
int: cap1 = 16;
int: cap2 = 24;

int: c_per_B = 2;
int: c_sell_cap = 5;
int: c_dispose_cost = 2;

int: profit_A = 4;
int: profit_B = 10;
int: profit_C = 3;

% Variables
var 0..cap1 div t1_A: xA;
var 0..cap1 div t1_B: xB;

var 0..(c_per_B * (cap1 div t1_B)): c_sold;
var 0..(c_per_B * (cap1 div t1_B)): c_disposed;

% Constraints
constraint t1_A * xA + t1_B * xB <= cap1;
constraint t2_A * xA + t2_B * xB <= cap2;

constraint c_sold + c_disposed = c_per_B * xB;
constraint c_sold <= c_sell_cap;

% Objective
solve maximize profit_A * xA + profit_B * xB + profit_C * c_sold - c_dispose_cost * c_disposed;