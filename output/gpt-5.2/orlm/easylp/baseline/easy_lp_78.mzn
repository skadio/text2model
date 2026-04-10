% Resource allocation between two construction projects (integer workers)

int: costX = 5000;
int: costY = 3000;

% Decision variables: number of workers assigned (nonnegative integers)
var 0..100: x; % workers on Project X
var 0..100: y; % workers on Project Y

% Constraints
constraint 2*x + y >= 8;
constraint x + 3*y <= 15;

% Objective: minimize total cost
var int: total_cost = costX * x + costY * y;
solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "minimum_cost = $", show(total_cost), "\n"
];