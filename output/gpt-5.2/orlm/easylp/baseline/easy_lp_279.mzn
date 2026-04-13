% Tourism package allocation - minimize total cost

int: capacity = 50;

int: costX = 150;
int: costY = 200;
int: costZ = 100;

% Decision variables: number of tourists in each package
var 0..capacity: X;
var 0..capacity: Y;
var 0..capacity: Z;

% Capacity constraint
constraint X + Y + Z <= capacity;

% Operational efficiency constraint: 2X + 3Y + Z >= 60
constraint 2*X + 3*Y + Z >= 60;

% Balance constraint: |Y - Z| <= 10
constraint abs(Y - Z) <= 10;

% Objective: minimize total cost
var int: total_cost = costX*X + costY*Y + costZ*Z;

solve minimize total_cost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "Z=", show(Z), "\n",
  "TotalCost=", show(total_cost), "\n"
];