% Manufacturing task-hour allocation (integer) with linear constraints and cost minimization

% Decision variables: hours for tasks x1..x4 (nonnegative integers)
var 0..100: x1;
var 0..100: x2;
var 0..100: x3;
var 0..100: x4;

% Constraints
constraint x1 + x2 <= 8;
constraint x3 >= x4 + 3;

% Avoid fractions by multiplying by 2
% x1 + 0.5*x2 - x3 <= 6  ==>  2*x1 + x2 - 2*x3 <= 12
constraint 2*x1 + x2 - 2*x3 <= 12;

% 0.5*x2 + x4 - x1 >= 0  ==>  x2 + 2*x4 - 2*x1 >= 0
constraint x2 + 2*x4 - 2*x1 >= 0;

% Objective: minimize total cost
var int: total_cost = 6*x1 + 7*x2 + 5*x3 + 4*x4;

solve minimize total_cost;

output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " x4=", show(x4), "\n",
  "Minimum total cost (rounded) = ", show(total_cost), "\n"
];