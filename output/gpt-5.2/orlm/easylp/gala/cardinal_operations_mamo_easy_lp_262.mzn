% Hiring plan: minimize total cost with minimum staffing and total hires cap.
% All data embedded as requested.

int: max_total = 100;

int: minX = 20;
int: minY = 30;
int: minZ = 10;

int: costX = 50000;
int: costY = 60000;
int: costZ = 70000;

var minX..max_total: x;   % hires in department X
var minY..max_total: y;   % hires in department Y
var minZ..max_total: z;   % hires in department Z

constraint x + y + z <= max_total;

var int: total_cost = costX * x + costY * y + costZ * z;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "z = ", show(z), "\n",
  "total_hires = ", show(x + y + z), "\n",
  "minimum_total_cost = $", show(total_cost), "\n"
];