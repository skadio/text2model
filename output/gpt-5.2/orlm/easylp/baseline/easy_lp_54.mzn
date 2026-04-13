% Restocking optimization (all data embedded)

int: costX = 4;
int: costY = 5;

% Bounds derived from constraints:
% x + 3y >= 10, 2x + y <= 15, x,y >= 0, integers
var 0..7: x;   % from 2x + y <= 15 and y >= 0 => x <= 7
var 0..15: y;  % from 2x + y <= 15 and x >= 0 => y <= 15

constraint x + 3*y >= 10;
constraint 2*x + y <= 15;

var int: total_cost = costX*x + costY*y;
solve minimize total_cost;

output [
  "x=", show(x), " y=", show(y), " total_cost=", show(total_cost), "\n",
  "Minimum total cost (nearest dollar) = ", show(total_cost), "\n"
];