include "globals.mzn";

% Investment decision variables (whole numbers)
% NOTE: The problem statement mentions "specific bounds on allocation" but does not provide them.
% We choose safe nonnegative bounds large enough to contain the optimum implied by constraints.
var 0..10000: x1;
var 0..10000: x2;
var 0..10000: x3;

% Objective: minimize total risk
% Risks: X1=2, X2=3, X3=4
var int: total_risk = 2*x1 + 3*x2 + 4*x3;

% Constraints
constraint 5*x1 + 7*x2 + 8*x3 >= 1500;

% x1 - 3/4 x2 - 1/2 x3 <= 200
% Multiply by 4 to keep integer arithmetic:
constraint 4*x1 - 3*x2 - 2*x3 <= 800;

% 2*x2 - x1 - x3 == 400
constraint 2*x2 - x1 - x3 = 400;

solve minimize total_risk;

output [
  "x1 = ", show(x1), "\n",
  "x2 = ", show(x2), "\n",
  "x3 = ", show(x3), "\n",
  "total_risk = ", show(total_risk), "\n"
];