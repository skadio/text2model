include "globals.mzn";

% Decision variables: integer resource allocations
var 0..100: x;  % resources for area X
var 0..100: y;  % resources for area Y
var 0..100: z;  % resources for area Z

% Total cost in dollars
var int: total_cost = 500*x + 300*y + 700*z;

% Constraints
constraint x + y + z <= 100;

% Minimum requirements
constraint x >= 20;
constraint y >= 30;
constraint z >= 10;

% "at least twice as much as that subtracted from" interpreted as:
% x >= 2*(y - x)  and  y >= 2*(z - y)
constraint x >= 2 * (y - x);
constraint y >= 2 * (z - y);

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "z = ", show(z), "\n",
  "total_cost = ", show(total_cost), "\n"
];