% Manufacturing production planning (integer variables), minimize total cost

var 0..100000: X1;
var 0..100000: X2;

% Constraints
constraint 10 * X1 + 15 * X2 <= 2000;          % machine capacity
constraint 12 * X1 + 6 * X2 >= 800;            % minimum productivity
constraint X1 - (X2 div 2) <= 100;             % balanced production line (integer half)

% Objective: minimize total cost
var int: total_cost = 50 * X1 + 75 * X2;
solve minimize total_cost;

output [
  "X1 = ", show(X1), "\n",
  "X2 = ", show(X2), "\n",
  "Minimum total cost ($) = ", show(total_cost), "\n"
];