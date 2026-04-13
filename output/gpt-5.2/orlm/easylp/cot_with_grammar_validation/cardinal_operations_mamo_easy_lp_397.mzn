% Parameters
int: c1 = 5;
int: c2 = 7;
int: c3 = 3;
int: c4 = 4;

float: rhs1 = 50.0;
float: rhs2 = 30.0;
float: rhs3 = 20.0;
float: rhs4 = 10.0;

% Variable bounds (not explicitly provided; assume nonnegative with a safe upper bound)
int: UB = 1000;

% Variables
var 0..UB: x1;
var 0..UB: x2;
var 0..UB: x3;
var 0..UB: x4;

var int: total_cost;

% Constraints
constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

constraint 2.0*int2float(x1) + 1.0*int2float(x2) - 0.5*int2float(x3) <= rhs1;
constraint 1.0*int2float(x1) + 2.5*int2float(x2) - 1.0*int2float(x4) >= rhs2;
constraint -0.75*int2float(x1) + 1.0*int2float(x3) + 1.0*int2float(x4) <= rhs3;
constraint -1.0*int2float(x1) - 1.0*int2float(x2) + 0.6*int2float(x4) >= rhs4;

% Objective
solve minimize total_cost;