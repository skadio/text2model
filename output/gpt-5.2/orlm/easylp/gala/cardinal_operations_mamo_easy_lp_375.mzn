% HR allocation / hiring-cost minimization (all data embedded)

% Decision variables: number of employees in each department (whole numbers)
var 0..20: x1;   % Marketing (max 20)
var 0..15: x2;   % Sales (max 15)
var 0..10: x3;   % Finance (max 10)
var 0..5:  x4;   % IT (max 5)

% Constraints
constraint x1 + x2 <= 40;
constraint x2 + x3 <= 30;
constraint x3 + x4 <= 20;

% x1 must be at least half of x4 plus 10:
% x1 >= x4/2 + 10  <=>  2*x1 >= x4 + 20 (integer-safe)
constraint 2 * x1 >= x4 + 20;

% Objective: minimize total hiring cost
var int: total_cost = 50*x1 + 70*x2 + 90*x3 + 110*x4;

solve minimize total_cost;

output [
  "x1 = ", show(x1), "\n",
  "x2 = ", show(x2), "\n",
  "x3 = ", show(x3), "\n",
  "x4 = ", show(x4), "\n",
  "minimum_total_cost = ", show(total_cost), "\n"
];