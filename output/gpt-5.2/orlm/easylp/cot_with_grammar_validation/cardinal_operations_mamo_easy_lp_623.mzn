% Parameters
int: c1 = 4;
int: c2 = 3;
int: c3 = 5;
int: c4 = 6;

int: cap12 = 1000;
int: rhs_2x2_plus_x3 = 500;
int: rhs_halfx3_minus_x1 = 200;
int: rhs_x4_minus_x2 = -400;
int: rhs_08x4_minus_x3 = -300;

% To avoid fractional coefficients, scale constraints by 2 or 10 where needed
% (0.5*x3 - x1 <= 200)  <=>  (x3 - 2*x1 <= 400)
% (0.8*x4 - x3 <= -300) <=>  (8*x4 - 10*x3 <= -3000)

% Variables
% Nonnegative integer allocations; explicit upper bounds are not given,
% so use safe finite bounds implied by constraints.
var 0..1000: X1;
var 0..1000: X2;
var 0..3000: X3;
var 0..3000: X4;

var 0..10000000: total_cost;

% Constraints
constraint X1 + X2 <= cap12;

constraint 2*X2 + X3 >= rhs_2x2_plus_x3;

constraint X3 - 2*X1 <= 2*rhs_halfx3_minus_x1;

constraint X4 - X2 >= rhs_x4_minus_x2;

constraint 8*X4 - 10*X3 <= 10*rhs_08x4_minus_x3;

constraint total_cost = c1*X1 + c2*X2 + c3*X3 + c4*X4;

% Objective
solve minimize total_cost;