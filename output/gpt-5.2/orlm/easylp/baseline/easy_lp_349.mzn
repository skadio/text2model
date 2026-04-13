% Hospital resource allocation - minimize total cost
% Departments: X (General Medicine), Y (Surgery), Z (Pediatrics), W (Geriatrics)

% Costs per unit resource
int: costX = 30;
int: costY = 20;
int: costZ = 40;
int: costW = 50;

% Decision variables: whole-number resources for each department
var 0..100000: X;
var 0..100000: Y;
var 0..100000: Z;
var 0..100000: W;

% Constraints
constraint X + Y >= 100;
constraint Z + W <= 200;
constraint X + Z >= 150;
constraint abs(Y - W) <= 50;

% Objective: minimize total cost
var int: total_cost = costX*X + costY*Y + costZ*Z + costW*W;
solve minimize total_cost;

output [
  "X (General Medicine) = ", show(X), "\n",
  "Y (Surgery)          = ", show(Y), "\n",
  "Z (Pediatrics)       = ", show(Z), "\n",
  "W (Geriatrics)       = ", show(W), "\n",
  "Minimum total cost ($) = ", show(total_cost), "\n"
];