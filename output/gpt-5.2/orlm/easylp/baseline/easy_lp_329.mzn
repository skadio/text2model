% Marketing budget allocation optimization (all-in-one MiniZinc model)

% Decision variables: integer allocations for activities x1..x4
% Nonnegative integer budgets; add reasonable upper bounds to keep the IP bounded.
int: UB = 1000;
var 0..UB: x1;
var 0..UB: x2;
var 0..UB: x3;
var 0..UB: x4;

% Constraints
constraint x1 + x2 <= 100;
constraint 2*x1 + x3 >= 150;
constraint x2 - 3*x4 <= 50;
constraint x3 - x4 >= 20;

% Objective: minimize total cost
var int: total_cost = 2*x1 + 3*x2 + 5*x3 + 4*x4;
solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "x4=", show(x4), "\n",
  "min_total_cost=", show(total_cost), "\n"
];