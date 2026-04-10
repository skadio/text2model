% Parameters
int: costX = 5;              % Cost per unit on ship X
int: costY = 7;              % Cost per unit on ship Y
int: costZ = 3;              % Cost per unit on ship Z

int: maxX = 100;             % Maximum cargo capacity for ship X
int: maxY = 80;              % Maximum cargo capacity for ship Y
int: maxZ = 60;              % Maximum cargo capacity for ship Z

int: min_constraint1 = 30;   % RHS for 2*X + 3*Y + Z >= 30
int: max_constraint2 = 50;   % RHS for X + 4*Y + 2*Z <= 50
int: min_constraint3 = 10;   % RHS for X - Y + Z >= 10

% Variables
var 0..maxX: cargoX;         % Integer cargo allocated to ship X
var 0..maxY: cargoY;         % Integer cargo allocated to ship Y
var 0..maxZ: cargoZ;         % Integer cargo allocated to ship Z

var int: totalCost;          % Total shipping cost (integer)

% Constraints
% Capacity/domain constraints are already enforced by variable bounds.

% Regulatory / operational linear constraints
constraint 2 * cargoX + 3 * cargoY + cargoZ >= min_constraint1;   % Minimum combined requirement
constraint cargoX + 4 * cargoY + 2 * cargoZ <= max_constraint2;   % Maximum combined limit
constraint cargoX - cargoY + cargoZ >= min_constraint3;           % Difference/offset requirement

% Total cost definition
constraint totalCost = costX * cargoX + costY * cargoY + costZ * cargoZ;

% Objective
solve minimize totalCost;

% Optional output (helps view solution and minimum cost)
output [
  "cargoX=", show(cargoX), "\n",
  "cargoY=", show(cargoY), "\n",
  "cargoZ=", show(cargoZ), "\n",
  "totalCost=", show(totalCost), "\n"
];