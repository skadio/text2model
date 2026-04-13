% Retail ordering optimization (all data embedded)

int: max_total_units = 5000;

int: costX = 5;
int: costY = 10;
int: costZ = 20;

% Decision variables: units ordered (whole numbers)
var 0..max_total_units: X;
var 0..max_total_units: Y;
var 0..max_total_units: Z;

% Constraints
constraint X + Y + Z <= max_total_units;

% X must be at least 1000 more than half of Y:
% X >= 0.5*Y + 1000  <=>  2X >= Y + 2000
constraint 2*X >= Y + 2000;

% Z should not exceed 75% of X by more than 1500:
% Z <= 0.75*X + 1500  <=>  4Z <= 3X + 6000
constraint 4*Z <= 3*X + 6000;

% Objective: minimize total cost
var int: total_cost = costX*X + costY*Y + costZ*Z;
solve minimize total_cost;

output [
  "X=", show(X), " Y=", show(Y), " Z=", show(Z), "\n",
  "Minimum total cost (USD) = ", show(total_cost), "\n"
];