% Resource allocation among projects X, Y, Z (all integer allocations)

var int: X;
var int: Y;
var int: Z;

% Nonnegativity (natural for "allocation of resources")
constraint X >= 0 /\ Y >= 0 /\ Z >= 0;

% Constraints
constraint X + Y <= 1000;
constraint 2*X + Z >= 500;
constraint abs(Y - Z) = 200;
constraint X + Z <= 800;

% Objective: minimize total cost
var int: total_cost = 2*X + 3*Y + 1*Z;
solve minimize total_cost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "Z=", show(Z), "\n",
  "minimum_total_cost=", show(total_cost), "\n"
];