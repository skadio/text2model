% Shift scheduling cost minimization

var 0..100: x; % number of shifts for type X workers
var 0..100: y; % number of shifts for type Y workers

% Constraints
constraint x + y >= 10;
constraint x <= 2*y + 4;

% Objective: minimize total wage cost
var int: cost = 8*x + 5*y;
solve minimize cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "min_cost = $", show(cost), "\n"
];