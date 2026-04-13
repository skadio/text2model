include "globals.mzn";

% Data (embedded as requested)
array[1..4] of int: cost = [5, 7, 3, 4]; % x1,x2,x3,x4

% Variable upper bounds are not specified numerically in the statement.
% Use safe, sufficiently large bounds implied by constraints to keep the model finite.
int: UB = 200;

% Decision variables: whole-number (indivisible) allocations
var 0..UB: x1;
var 0..UB: x2;
var 0..UB: x3;
var 0..UB: x4;

% Constraints, written without fractions by multiplying through:
% 1) 2*x1 + x2 - 0.5*x3 <= 50  =>  4*x1 + 2*x2 - x3 <= 100
constraint 4*x1 + 2*x2 - x3 <= 100;

% 2) x1 + 2.5*x2 - x4 >= 30  =>  2*x1 + 5*x2 - 2*x4 >= 60
constraint 2*x1 + 5*x2 - 2*x4 >= 60;

% 3) x3 + x4 - 0.75*x1 <= 20  =>  4*x3 + 4*x4 - 3*x1 <= 80
constraint 4*x3 + 4*x4 - 3*x1 <= 80;

% 4) (x4*0.6) - x1 - x2 >= 10  =>  3*x4 - 5*x1 - 5*x2 >= 50
constraint 3*x4 - 5*x1 - 5*x2 >= 50;

% Objective: minimize total cost
var int: total_cost = cost[1]*x1 + cost[2]*x2 + cost[3]*x3 + cost[4]*x4;

solve minimize total_cost;

output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " x4=", show(x4), "\n",
  "Minimum total cost (integer) = ", show(total_cost), "\n"
];