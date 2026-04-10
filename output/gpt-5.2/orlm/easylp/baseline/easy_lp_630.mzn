% Resource allocation across 4 departments with embedded data

% Costs per unit
array[1..4] of int: cost = [500, 600, 800, 700];

% Bounds (not explicitly provided in the description; use nonnegative integer allocations)
array[1..4] of int: lb = [0, 0, 0, 0];
array[1..4] of int: ub = [100, 100, 50, 50];  % consistent with the pairwise caps

var lb[1]..ub[1]: x1;
var lb[2]..ub[2]: x2;
var lb[3]..ub[3]: x3;
var lb[4]..ub[4]: x4;

constraint x1 + x2 <= 100;
constraint x3 + x4 <= 50;

% "x3 at least twice of that reduced from x1" interpreted as x3 >= 2*x1
constraint x3 >= 2 * x1;

% "x4 no less than three quarters of that reduced from x2" interpreted as x4 >= 3/4 * x2
% Avoid fractions: 4*x4 >= 3*x2
constraint 4 * x4 >= 3 * x2;

% Rebalancing constraint
constraint (x3 + x4) - (x1 + x2) >= 30;

var int: total_cost = cost[1]*x1 + cost[2]*x2 + cost[3]*x3 + cost[4]*x4;

solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "x4=", show(x4), "\n",
  "total_cost=", show(total_cost), "\n"
];