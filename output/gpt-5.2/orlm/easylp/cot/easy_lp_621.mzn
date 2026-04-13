% Parameters (with values embedded)
int: cost1 = 2;
int: cost2 = 3;
int: cost3 = 5;
int: cost4 = 4;

int: cap12 = 1000;
int: cap34 = 1200;

% NOTE: The problem statement mentions "specific bounds on resource allocation for each process"
% but does not provide numeric bounds. We model non-negativity explicitly.
int: LB = 0;
int: UB = 1200; % safe explicit upper bound implied by the capacity limits

% Variables
var LB..UB: x1;
var LB..UB: x2;
var LB..UB: x3;
var LB..UB: x4;

var 0..(cost1*UB + cost2*UB + cost3*UB + cost4*UB): total_cost;

% Constraints
constraint x1 + x2 <= cap12;
constraint x3 + x4 <= cap34;

% x1 >= (4/3)*x3  <=>  3*x1 >= 4*x3
constraint 3 * x1 >= 4 * x3;

% x2 >= (9/7)*x4 + 200  <=>  7*x2 >= 9*x4 + 1400
constraint 7 * x2 >= 9 * x4 + 1400;

constraint total_cost = cost1*x1 + cost2*x2 + cost3*x3 + cost4*x4;

% Objective
solve minimize total_cost;