% Parameters
int: max_total = 1000;
int: cost1 = 500;
int: cost2 = 600;
int: cost3 = 700;

% To avoid fractions: 2*(2*X1 - 0.5*X2) >= 2*200  =>  4*X1 - X2 >= 400
int: rhs_diff12 = 400;

% 2*X3 - X1 <= 300
int: rhs_diff31 = 300;

% Variable upper bounds implied by max_total
int: UB = max_total;

% Variables
var 0..UB: X1;
var 0..UB: X2;
var 0..UB: X3;

var 0..(cost1*UB + cost2*UB + cost3*UB): total_cost;

% Constraints
constraint X1 + X2 + X3 <= max_total;

constraint 4*X1 - X2 >= rhs_diff12;

constraint 2*X3 - X1 <= rhs_diff31;

constraint total_cost = cost1*X1 + cost2*X2 + cost3*X3;

% Objective
solve minimize total_cost;