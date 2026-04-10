% Marketing budget allocation among destinations X, Y, Z
% Minimize total cost subject to investment constraints

var 0..100: x;   % investment units in destination X
var 0..150: y;   % investment units in destination Y
var 0..150: z;   % investment units in destination Z

% Constraints
constraint x + y <= 100;
constraint y + z <= 150;
constraint x + z >= 50;

% Costs per unit
int: costX = 10;
int: costY = 15;
int: costZ = 20;

var int: total_cost = costX * x + costY * y + costZ * z;

solve minimize total_cost;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "z=", show(z), "\n",
  "total_cost=", show(total_cost), "\n"
];