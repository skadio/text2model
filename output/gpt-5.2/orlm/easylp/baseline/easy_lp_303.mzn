% Environmental projects optimization (all data embedded)

int: costX = 2;
int: costY = 3;
int: costZ = 1;

% Effort variables (whole numbers, nonnegative)
var int: x; % Project X effort
var int: y; % Project Y effort
var int: z; % Project Z effort

constraint x >= 0 /\ y >= 0 /\ z >= 0;

% Constraints
constraint x + y >= 10;
constraint 2 * x + z <= 15;
constraint y - z >= 5;

% Objective: minimize total resources used
var int: total_resource = costX * x + costY * y + costZ * z;
solve minimize total_resource;

output [
  "x=", show(x), " y=", show(y), " z=", show(z), "\n",
  "min_total_resource=", show(total_resource), "\n"
];