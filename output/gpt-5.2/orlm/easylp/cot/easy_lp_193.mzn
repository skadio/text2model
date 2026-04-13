% Parameters (with values embedded)
int: max_vehicles = 1000;
int: min_X = 300;
int: min_Y = 200;
int: min_Z = 150;

int: cost_X = 3;
int: cost_Y = 2;
int: cost_Z = 5;

% Variables
var 0..max_vehicles: x;
var 0..max_vehicles: y;
var 0..max_vehicles: z;

% Constraints
constraint x >= min_X;
constraint y >= min_Y;
constraint z >= min_Z;

constraint x + y + z <= max_vehicles;

% Objective
solve minimize cost_X * x + cost_Y * y + cost_Z * z;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "z=", show(z), "\n",
  "min_total_cost=", show(cost_X * x + cost_Y * y + cost_Z * z), "\n"
];