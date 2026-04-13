% Resource allocation for projects X, Y, Z (integer units)
var 0..1000: X;
var 0..1000: Y;
var 0..1000: Z;

% Total resources cannot exceed 1000
constraint X + Y + Z <= 1000;

% Project X requires at least 200 more units than project Y
constraint X >= Y + 200;

% Difference between Z and X should not exceed 300 units
constraint abs(Z - X) <= 300;

% Combined allocation for projects Y and Z must be at least 500 units
constraint Y + Z >= 500;

% Impact points per unit: X=2, Y=3, Z=4
var int: total_impact = 2*X + 3*Y + 4*Z;

solve minimize total_impact;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "Z=", show(Z), "\n",
  "Minimum total impact points (already integer)=", show(total_impact), "\n"
];