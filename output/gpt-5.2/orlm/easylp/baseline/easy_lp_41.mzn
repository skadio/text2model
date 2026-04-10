% Portfolio allocation between investment options X and Y (integer allocations)

int: budget = 10000;
int: minX = 2000;
int: minY = 3000;

% Costs per dollar allocated (0.02 and 0.03)
float: costX = 0.02;
float: costY = 0.03;

var int: x; % dollars allocated to X
var int: y; % dollars allocated to Y

constraint x >= minX;
constraint y >= minY;
constraint x + y <= budget;

var float: total_cost = costX * int2float(x) + costY * int2float(y);

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "total_cost = ", show(total_cost), "\n",
  "total_cost_rounded = ", show(round(total_cost)), "\n"
];