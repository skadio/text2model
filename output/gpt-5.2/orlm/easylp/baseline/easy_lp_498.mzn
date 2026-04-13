% Real estate development: minimize total construction cost

var 0..15: x; % residential buildings
var 0..10: y; % commercial buildings

constraint x + y <= 20;

% Effort constraint: 2x + 0.5y >= 15  -> multiply by 2 to keep integer:
constraint 4*x + y >= 30;

% Aesthetic balance: |x - y| <= 5
constraint abs(x - y) <= 5;

% Costs in dollars
var int: total_cost = 30000 * x + 50000 * y;

solve minimize total_cost;

output [
  "x (residential) = ", show(x), "\n",
  "y (commercial)  = ", show(y), "\n",
  "total_cost ($)  = ", show(total_cost), "\n"
];