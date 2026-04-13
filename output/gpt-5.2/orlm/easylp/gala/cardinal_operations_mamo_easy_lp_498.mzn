% Real estate development optimization (all data embedded)

% Decision variables
var 0..15: x;  % residential buildings
var 0..10: y;  % commercial buildings

% Constraints
constraint x + y <= 20;                         % land limit
constraint 4 * x + y >= 30;                     % 2x + 0.5y >= 15  -> multiply by 2
constraint abs(x - y) <= 5;                     % aesthetic balance

% Objective: minimize total cost
var int: total_cost = 30000 * x + 50000 * y;

solve minimize total_cost;

output [
  "x (residential) = ", show(x), "\n",
  "y (commercial)  = ", show(y), "\n",
  "minimum_cost    = $", show(total_cost), "\n"
];