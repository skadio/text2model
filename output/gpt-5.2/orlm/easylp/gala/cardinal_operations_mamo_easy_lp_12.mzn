% Energy company resource allocation optimization (integer variables)

% Data (embedded, as requested)
int: max_total = 100;
int: min_effect = 50;
int: max_diff = 30;

int: costX = 5;
int: costY = 8;

% Decision variables (integer allocations)
var 0..max_total: x;  % resources to project X
var 0..max_total: y;  % resources to project Y

% Constraints
constraint x + y <= max_total;
constraint 2*x + y >= min_effect;
constraint abs(x - y) <= max_diff;

% Objective: minimize total cost
var 0..(costX*max_total + costY*max_total): total_cost = costX*x + costY*y;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "minimum_total_cost = ", show(total_cost), "\n"
];