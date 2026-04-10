% Crop resource allocation / minimum cost
% All data embedded as per instructions.

int: MAX_RES = 5000;

int: costX = 100;
int: costY = 200;
int: costZ = 150;

% Decision variables: integer units allocated to each crop
var 0..MAX_RES: x;
var 0..MAX_RES: y;
var 0..MAX_RES: z;

% Total resources cannot exceed 5000
constraint x + y + z <= MAX_RES;

% X at least three times Y; Z at least twice Y
constraint x >= 3 * y;
constraint z >= 2 * y;

% Objective: minimize total cost
var 0..(MAX_RES * max([costX,costY,costZ])): total_cost =
  costX * x + costY * y + costZ * z;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "z = ", show(z), "\n",
  "min_cost = ", show(total_cost), "\n"
];