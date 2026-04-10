% Marketing budget allocation problem (all data embedded)

% Decision variables: budgets in dollars (integers)
var 0..5000: x;  % Channel X budget
var 0..5000: y;  % Channel Y budget

% Constraints
constraint x + y <= 5000;
constraint 3*x - 2*y >= 2000;
constraint x - y <= 1000;

% Objective: minimize total cost in dollars
% Cost per unit: X = 1000, Y = 1500
var int: total_cost = 1000*x + 1500*y;
solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "minimum_total_cost = $", show(total_cost), "\n"
];