% Budget allocation between two campaigns X and Y (integer dollars)

var 0..100: x; % dollars allocated to campaign X
var 0..100: y; % dollars allocated to campaign Y

% Constraints
constraint x + y <= 100;
constraint 2*x + 3*y >= 150;

% Cost: $20 per dollar in X and $30 per dollar in Y
var int: total_cost = 20*x + 30*y;

solve minimize total_cost;

output [
  "x=", show(x), " y=", show(y), " total_cost=", show(total_cost), "\n"
];