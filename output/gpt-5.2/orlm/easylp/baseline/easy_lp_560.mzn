% Tourism budget allocation optimization (all data embedded)

var int: X; % Promotion of local attractions
var int: Y; % Development of tourist infrastructure
var int: Z; % Training for tourism service providers

% Constraints
constraint X >= 2000;
constraint Y <= 1000;
constraint Z >= 500;
constraint X + Y + Z <= 5000;

% Costs per unit effectiveness
int: cX = 50;
int: cY = 100;
int: cZ = 150;

% Objective: minimize total cost
var int: total_cost = cX * X + cY * Y + cZ * Z;

solve minimize total_cost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "Z=", show(Z), "\n",
  "minimum_total_cost=", show(total_cost), "\n"
];