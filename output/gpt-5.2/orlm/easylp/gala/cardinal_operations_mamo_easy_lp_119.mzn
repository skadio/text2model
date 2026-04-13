% Tourism agency trip planning (all data embedded)

% Decision variables: number of trips of each type (non-negative integers)
var 0..50: x;   % trips of type X
var 0..50: y;   % trips of type Y

% Constraints
constraint x + y <= 50;
constraint 2*x + 3*y >= 30;

% Objective: minimize total investment cost
var int: total_cost = 100*x + 200*y;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "minimum_total_investment = $", show(total_cost), "\n"
];