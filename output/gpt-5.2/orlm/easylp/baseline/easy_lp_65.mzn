% Bandwidth allocation problem (integer allocations)

var 0..10000: x; % units allocated to service X
var 0..10000: y; % units allocated to service Y

% Total bandwidth limit
constraint x + y <= 10000;

% Service quality constraints (avoid fractions by multiplying)
% x - 0.5y >= 3000  <=> 2x - y >= 6000
constraint 2*x - y >= 6000;

% y - 0.75x <= 2000 <=> 4y - 3x <= 8000
constraint 4*y - 3*x <= 8000;

% Objective: minimize total cost
var int: total_cost = 20*x + 30*y;
solve minimize total_cost;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "min_total_cost=", show(total_cost), "\n"
];