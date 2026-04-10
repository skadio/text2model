% Resource allocation between Project X and Project Y
% Minimize total cost with integer allocations

var 0..1000: x;  % resources to Project X
var 0..1000: y;  % resources to Project Y

constraint x + 2 * y <= 100;
constraint 3 * x - y >= 50;

var int: total_cost = 4 * x + 5 * y;

solve minimize total_cost;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "min_total_cost=", show(total_cost), "\n"
];