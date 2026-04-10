% Military logistics resource allocation (all data embedded)

int: max_units = 1000;

% Constraints
int: req_strength = 200;        % 2*X + Y >= 200
int: req_xz = 300;              % X + Z >= 300

% Resource points per unit
int: costX = 300;
int: costY = 500;
int: costZ = 700;

% Decision variables (integers, nonnegative)
var 0..max_units: X;
var 0..max_units: Y;
var 0..max_units: Z;

% Objective
var int: total_points = costX*X + costY*Y + costZ*Z;

constraint X + Y + Z <= max_units;
constraint 2*X + Y >= req_strength;
constraint X + Z >= req_xz;

solve minimize total_points;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "Z=", show(Z), "\n",
  "min_total_resource_points=", show(total_points), "\n"
];