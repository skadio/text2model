include "globals.mzn";

% Decision variables: integer investments in projects X, Y, Z (units)
var 0..1000: X;
var 0..1000: Y;
var 0..1000: Z;

% Constraints
constraint X + Y + Z <= 1000;          % total budget
constraint 3*X + 2*Y >= 400;           % minimum combined strength
constraint abs(Z - Y) <= 300;          % balance between Z and Y
constraint X > 2*Z;                    % X strictly greater than twice Z

% Costs per unit
int: cX = 300;
int: cY = 500;
int: cZ = 200;

% Objective: minimize total cost
var int: total_cost = cX*X + cY*Y + cZ*Z;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total cost = $", show(total_cost), "\n"
];