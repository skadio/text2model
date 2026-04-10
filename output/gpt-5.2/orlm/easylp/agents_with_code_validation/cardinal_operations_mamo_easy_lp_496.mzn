% Parameters
int: totalCapacity = 2000;          % Combined capacity limit
int: capPerShipX  = 4;              % Capacity used per unit shipped to Port X
int: capPerShipY  = 5;              % Capacity used per unit shipped to Port Y

int: minDiffXY    = 50;             % Minimum required (X - Y)
int: comboLimit   = 1500;           % Upper bound on (X + 2*Y)

int: costPerShipX = 2;              % Cost per unit shipped to Port X
int: costPerShipY = 3;              % Cost per unit shipped to Port Y

% Variables
var 0..(totalCapacity div capPerShipX): shipX;  % Integer units shipped to Port X
var 0..(totalCapacity div capPerShipY): shipY;  % Integer units shipped to Port Y

var 0..(costPerShipX*(totalCapacity div capPerShipX)
      + costPerShipY*(totalCapacity div capPerShipY)): totalCost; % Total cost ($)

% Constraints
% Capacity constraint: combined capacity usage at both ports cannot exceed totalCapacity
constraint capPerShipX * shipX + capPerShipY * shipY <= totalCapacity;

% Balance constraint: shipments to Port X must exceed shipments to Port Y by at least minDiffXY
constraint shipX - shipY >= minDiffXY;

% Logistics constraint: combined shipment volume (X + 2*Y) cannot exceed comboLimit
constraint shipX + 2 * shipY <= comboLimit;

% Cost definition constraint: totalCost equals the sum of per-port shipment costs
constraint totalCost = costPerShipX * shipX + costPerShipY * shipY;

% Objective
solve minimize totalCost;

output [
  "shipX = ", show(shipX), "\n",
  "shipY = ", show(shipY), "\n",
  "totalCost = ", show(totalCost), "\n"
];