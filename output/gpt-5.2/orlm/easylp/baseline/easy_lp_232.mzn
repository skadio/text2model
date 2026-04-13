% Resource allocation across X, Y, Z with embedded data

var 0..1000: x;
var 0..1000: y;
var 0..1000: z;

% Total resources cannot exceed 1000
constraint x + y + z <= 1000;

% Production target: 4x + 5y >= 3000
constraint 4*x + 5*y >= 3000;

% Interdependency: z - 3y >= -500  <=>  z >= 3y - 500
constraint z - 3*y >= -500;

% Minimize total cost: 2x + 3y + 1z
var int: total_cost = 2*x + 3*y + z;
solve minimize total_cost;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "z=", show(z), "\n",
  "minimum_total_cost=", show(total_cost), "\n"
];