% Construction resource allocation: minimize cost with integer workers

% Data (embedded)
int: min_requirement = 8;      % 2X + Y >= 8
int: max_budget      = 15;     % X + 3Y <= 15
int: costX = 5000;
int: costY = 3000;

% Decision variables (nonnegative integers)
var 0..100: x;   % workers on Project X
var 0..100: y;   % workers on Project Y

% Constraints
constraint 2 * x + y >= min_requirement;
constraint x + 3 * y <= max_budget;

% Objective: minimize total cost
var int: total_cost = costX * x + costY * y;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "min_cost = $", show(total_cost), "\n"
];