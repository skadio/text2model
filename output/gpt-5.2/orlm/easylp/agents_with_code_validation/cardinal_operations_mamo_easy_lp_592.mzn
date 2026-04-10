% Transportation resource allocation (integer) - minimize total cost
% All data embedded as per problem statement.

% Parameters
int: cap_12 = 300;   % x1 + x2 <= 300
int: cap_34 = 500;   % x3 + x4 <= 500
int: rhs_weighted_min = 100; % 0.7*x2 - x1 - x3 + 0.9*x4 >= 100
int: rhs_other_max    = 200; % (x3 - 0.8*x4) - (x1 + x2) <= 200

% Decision variables (nonnegative integers)
var 0..cap_12: x1;
var 0..cap_12: x2;
var 0..cap_34: x3;
var 0..cap_34: x4;

% Work in scaled integers to avoid float constraints (prevents Gecode float linear issues)
% Cost scaling by 10: cost10 = 5*x1 + 6*x2 + 8*x3 + 12*x4
var 0..(5*cap_12 + 6*cap_12 + 8*cap_34 + 12*cap_34): cost10;

% Constraints
constraint x1 + x2 <= cap_12;
constraint x3 + x4 <= cap_34;

% 0.7*x2 - x1 - x3 + 0.9*x4 >= 100
% Multiply by 10: 7*x2 - 10*x1 - 10*x3 + 9*x4 >= 1000
constraint 7*x2 - 10*x1 - 10*x3 + 9*x4 >= 10 * rhs_weighted_min;

% x3 - 0.8*x4 - x1 - x2 <= 200
% Multiply by 10: 10*x3 - 8*x4 - 10*x1 - 10*x2 <= 2000
constraint 10*x3 - 8*x4 - 10*x1 - 10*x2 <= 10 * rhs_other_max;

% Define scaled total cost (integer)
constraint cost10 = 5*x1 + 6*x2 + 8*x3 + 12*x4;

% Objective: minimize true cost => minimize cost10 (scaled by 10)
solve minimize cost10;

% Output (also show rounded-to-1-decimal cost)
output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " x4=", show(x4), "\n",
  "total_cost=", show(cost10 div 10), ".", show(cost10 mod 10), "\n"
];