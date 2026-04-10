% Resource allocation between warehouses X and Y
% Minimize total cost subject to budget and capacity constraints.

var 1000..5000: x;          % units allocated to warehouse X (min 1000)
var 0..3000: y;             % units allocated to warehouse Y (max 3000)

constraint x + y <= 5000;   % total allocation budget constraint

var int: total_cost = 50 * x + 75 * y;

solve minimize total_cost;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "total_cost=", show(total_cost), "\n"
];