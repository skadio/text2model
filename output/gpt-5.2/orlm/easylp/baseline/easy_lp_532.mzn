% Resource allocation optimization (all data embedded)

var int: X; % units allocated to project X
var int: Y; % units allocated to project Y
var int: Z; % units allocated to project Z

% Nonnegativity (resource units)
constraint X >= 0 /\ Y >= 0 /\ Z >= 0;

% Constraints from description
constraint X + Y >= 1000;
constraint abs(Y - Z) <= 500;
constraint X + Z = 1500;

% Unit costs
int: cX = 8;
int: cY = 5;
int: cZ = 2;

var int: total_cost = cX * X + cY * Y + cZ * Z;

solve minimize total_cost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "Z=", show(Z), "\n",
  "total_cost=", show(total_cost), "\n",
  "rounded_total_cost=", show(total_cost), "\n"
];