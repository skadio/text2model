% Parameters
% Cost coefficients (USD per unit) for projects X, Y, Z
int: costX = 5;
int: costY = 4;
int: costZ = 6;

% Constraint right-hand sides
int: rhs1 = 10; % 2*X + 3*Y + Z >= 10
int: rhs2 = 8;  % X - Y + Z <= 8
int: rhs3 = 3;  % Y - Z >= 3

% Variable bounds (non-negative whole units of resources)
int: maxAlloc = 100; % safe upper bound

% Variables
var 0..maxAlloc: x; % allocation to project X (integer units)
var 0..maxAlloc: y; % allocation to project Y (integer units)
var 0..maxAlloc: z; % allocation to project Z (integer units)

% Total cost variable (bounded using maxAlloc)
var 0..(costX*maxAlloc + costY*maxAlloc + costZ*maxAlloc): total_cost;

% Constraints
% Resource requirement: ensure minimum combined allocation
constraint 2*x + 3*y + z >= rhs1;

% Capacity/feasibility limit: X - Y + Z must not exceed allowed maximum
constraint x - y + z <= rhs2;

% Technology/manpower relation: Y must exceed Z by at least the required margin
constraint y - z >= rhs3;

% Define total cost from allocations and per-unit costs
constraint total_cost = costX*x + costY*y + costZ*z;

% Objective
solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "z = ", show(z), "\n",
  "minimum total cost = $", show(total_cost), "\n"
];