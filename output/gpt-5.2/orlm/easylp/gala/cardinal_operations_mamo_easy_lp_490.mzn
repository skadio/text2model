% Resource allocation MILP/IP model (all data embedded)

% Decision variables: number of units of each type (whole numbers)
var 0..10000: x;  % units of X
var 0..10000: y;  % units of Y

% Constraints
constraint 10 * x + 20 * y <= 3000;      % logistical capacity
constraint 3 * x + 5 * y >= 500;         % required combined strength
constraint abs(x - y) <= 1000;           % balance requirement

% Objective: minimize total support points (in dollars)
% Each X costs $10,000; each Y costs $20,000
var int: total_cost = 10000 * x + 20000 * y;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "minimum_total_cost_dollars = ", show(total_cost), "\n"
];