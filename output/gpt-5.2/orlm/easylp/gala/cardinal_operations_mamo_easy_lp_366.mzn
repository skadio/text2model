% Machinery rental optimization (all data embedded)

% Costs per machine per day
int: costX = 4000;
int: costY = 3000;
int: costZ = 6000;
int: costW = 5000;

% Maximum available machines of each type
int: maxX = 30;
int: maxY = 25;
int: maxZ = 20;
int: maxW = 15;

% Group budget/availability constraints
int: maxXY = 50;  % X + Y
int: maxZW = 40;  % Z + W

% Project minimum requirements
int: minXZ = 30;  % X + Z
int: minYW = 20;  % Y + W

% Decision variables: number of machines rented of each type
var 0..maxX: X;
var 0..maxY: Y;
var 0..maxZ: Z;
var 0..maxW: W;

% Constraints
constraint X + Y <= maxXY;
constraint Z + W <= maxZW;

constraint X + Z >= minXZ;
constraint Y + W >= minYW;

% Objective: minimize total daily rental cost
var int: totalCost = costX*X + costY*Y + costZ*Z + costW*W;

solve minimize totalCost;

output [
  "X=", show(X), " Y=", show(Y), " Z=", show(Z), " W=", show(W), "\n",
  "Total daily cost = $", show(totalCost), "\n"
];