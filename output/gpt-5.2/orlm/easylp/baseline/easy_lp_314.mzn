% Resource allocation for Operations X, Y, Z (integer units)
int: max_resources = 100;

int: costX = 5000;
int: costY = 4000;
int: costZ = 6000;

int: effX = 5;
int: effY = 3;
int: effZ = 7;

int: min_effectiveness = 350;

var 0..max_resources: x; % Operation X
var 0..max_resources: y; % Operation Y
var 0..max_resources: z; % Operation Z

constraint x + y + z <= max_resources;

constraint effX*x + effY*y + effZ*z >= min_effectiveness;

% Strategy requirement: 2*(X + Y) subtracted from Z should be non-negative
% i.e., z - 2x - 2y >= 0
constraint z - 2*x - 2*y >= 0;

var int: total_cost = costX*x + costY*y + costZ*z;

solve minimize total_cost;

output [
  "x=", show(x), " y=", show(y), " z=", show(z), "\n",
  "total_cost=", show(total_cost), "\n"
];