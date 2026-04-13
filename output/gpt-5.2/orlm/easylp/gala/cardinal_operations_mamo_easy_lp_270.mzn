% Hiring plan optimization (all data embedded)

include "globals.mzn";

% Decision variables: integer number of hires in each department
var 0..50: x;   % Dept X capacity 50
var 0..30: y;   % Dept Y capacity 30
var 0..20: z;   % Dept Z capacity 20

% Total hires cannot exceed 100
constraint x + y + z <= 100;

% Strategic staffing ratio constraints
constraint x >= 2 * y + 10;
constraint y >= z + 5;

% Costs per hire
int: costX = 5000;
int: costY = 6000;
int: costZ = 7000;

var int: totalCost = costX * x + costY * y + costZ * z;

solve minimize totalCost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "z = ", show(z), "\n",
  "total_hires = ", show(x + y + z), "\n",
  "total_cost = $", show(totalCost), "\n"
];