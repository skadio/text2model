% Supply chain resource allocation optimization (all data embedded)

var 0..10000: X; % procurement
var 0..10000: Y; % manufacturing
var 0..10000: Z; % distribution

% Constraints
constraint X + Y <= 1000;
constraint Y + Z >= 500;
constraint abs(X - Z) <= 200;

% Costs per unit
int: cX = 4;
int: cY = 3;
int: cZ = 2;

var int: total_cost = cX * X + cY * Y + cZ * Z;

solve minimize total_cost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "Z=", show(Z), "\n",
  "minimum_total_cost=", show(total_cost), "\n"
];