% Marketing resource allocation (all data embedded)

% Decision variables: integer resource units allocated to channels
var 0..1000: x;   % Channel X
var 0..1000: y;   % Channel Y
var 0..1000: z;   % Channel Z

% Budget/resource cap
constraint x + y + z <= 1000;

% Effectiveness constraints
constraint x >= 2 * y;
constraint x + y >= 200;

constraint y + 2 * z >= 300;

% Costs per unit (in dollars)
int: cx = 10;
int: cy = 15;
int: cz = 20;

var int: total_cost = cx * x + cy * y + cz * z;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "z = ", show(z), "\n",
  "total_cost = ", show(total_cost), "\n"
];