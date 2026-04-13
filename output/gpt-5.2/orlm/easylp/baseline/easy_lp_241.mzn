% Resource allocation for projects X, Y, Z (all data embedded)

var 0..20: X; % residential
var 0..20: Y; % commercial
var 0..20: Z; % infrastructure

% Total projects limit
constraint X + Y + Z <= 20;

% Portfolio diversity: X + 0.5*Y >= 5  <=>  2X + Y >= 10
constraint 2*X + Y >= 10;

% Expertise constraint: Y + Z <= 10
constraint Y + Z <= 10;

% Cost (in dollars)
var int: total_cost = 1000*X + 2000*Y + 1500*Z;

solve minimize total_cost;

output [
  "X=", show(X), " Y=", show(Y), " Z=", show(Z), "\n",
  "minimum_total_cost=$", show(total_cost), "\n"
];