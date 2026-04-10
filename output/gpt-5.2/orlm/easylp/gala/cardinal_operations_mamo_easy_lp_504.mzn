include "globals.mzn";

/*
  Budget allocation (integers) to three channels X1, X2, X3.

  Constraints:
   - 0 <= X1 <= 5000, 0 <= X2 <= 4000, 0 <= X3 <= 3000
   - X1 + X2 + X3 <= 10000
   - Effectiveness: 2*X1 - 3*X2 + 4.5*X3 >= 2000
   - Balance: | 0.5*X2 - X1 - 0.75*X3 | <= 1500
  Objective:
   - Minimize total cost: 5000*X1 + 3000*X2 + 7000*X3
*/

% Decision variables (budgets)
var 0..5000: X1;
var 0..4000: X2;
var 0..3000: X3;

% Total budget limit
constraint X1 + X2 + X3 <= 10000;

% Effectiveness constraint (clear fractions by multiplying by 2):
% 2*X1 - 3*X2 + 4.5*X3 >= 2000
% => 4*X1 - 6*X2 + 9*X3 >= 4000
constraint 4*X1 - 6*X2 + 9*X3 >= 4000;

% Balance constraint (clear fractions by multiplying by 4):
% |0.5*X2 - X1 - 0.75*X3| <= 1500
% => |2*X2 - 4*X1 - 3*X3| <= 6000
constraint abs(2*X2 - 4*X1 - 3*X3) <= 6000;

% Objective: minimize total cost
var int: total_cost = 5000*X1 + 3000*X2 + 7000*X3;

solve minimize total_cost;

output [
  "X1 = ", show(X1), "\n",
  "X2 = ", show(X2), "\n",
  "X3 = ", show(X3), "\n",
  "Minimum total cost (rounded) = ", show(total_cost), "\n"
];