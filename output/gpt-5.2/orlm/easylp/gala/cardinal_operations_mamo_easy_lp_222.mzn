% Retail space allocation for products X, Y, Z
% Data embedded as required.

int: total_space = 1000;

int: minX = 200;
int: minY = 150;
int: minZ = 100;

int: revX = 5;   % $ per m^2
int: revY = 3;
int: revZ = 2;

% Decision variables: whole-number square meters allocated
var minX..total_space: x;
var minY..total_space: y;
var minZ..total_space: z;

% Total space constraint
constraint x + y + z <= total_space;

% Objective: minimize total "cost" (as stated); using given $/m^2 coefficients
var int: total_cost = revX * x + revY * y + revZ * z;
solve minimize total_cost;

output [
  "x = ", show(x), " m^2\n",
  "y = ", show(y), " m^2\n",
  "z = ", show(z), " m^2\n",
  "total_space_used = ", show(x+y+z), " m^2\n",
  "minimum_total_cost = $", show(total_cost), "\n"
];