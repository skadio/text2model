include "globals.mzn";

% Costs per unit resource
int: cX = 30; % General Medicine
int: cY = 20; % Surgery
int: cZ = 40; % Pediatrics
int: cW = 50; % Geriatrics

% Decision variables: whole-number units of resources
var 0..10000: X;
var 0..10000: Y;
var 0..10000: Z;
var 0..10000: W;

% Constraints
constraint X + Y >= 100;
constraint Z + W <= 200;
constraint X + Z >= 150;
constraint abs(Y - W) <= 50;

% Objective: minimize total cost
var int: totalCost = cX*X + cY*Y + cZ*Z + cW*W;
solve minimize totalCost;

output [
  "X (General Medicine) = ", show(X), "\n",
  "Y (Surgery)          = ", show(Y), "\n",
  "Z (Pediatrics)       = ", show(Z), "\n",
  "W (Geriatrics)       = ", show(W), "\n",
  "Minimum total cost   = $", show(totalCost), "\n"
];