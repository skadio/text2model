% Shipping fleet allocation: minimize operational cost

% Decision variables: number of ships of type X and Y (integers)
var 0..1000: x;
var 0..1000: y;

% Constraints
constraint x + y <= 1000;                 % total ships limit
constraint 2 * x + y >= 800;              % capacity requirement
constraint x - (y div 2) <= 200;          % difference constraint using half of Y (integer half)

% Objective: minimize cost
var int: cost = 8 * x + 15 * y;
solve minimize cost;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "min_cost_dollars=", show(cost), "\n"
];