% Shipping cost minimization with integer cargo units

var 0..100: x; % units of cargo X
var 0..100: y; % units of cargo Y

% Capacity constraint (tons)
constraint 2*x + 3*y <= 30;

% Contract requirement: combined weight of 4 units of X and 1 unit of Y >= 10 tons
constraint 4*(2*x) + 1*(3*y) >= 10;

% Objective: minimize total transportation cost (dollars)
var int: total_cost = 5*x + 7*y;
solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "total_cost = ", show(total_cost), "\n"
];