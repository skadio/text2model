% Resource allocation optimization for three departments (X, Y, Z)

var int: X; % patient care
var int: Y; % research and development
var int: Z; % administrative tasks

% Basic nonnegativity (resource units)
constraint X >= 0 /\ Y >= 0 /\ Z >= 0;

% Constraints from the description
constraint X + Y <= 150;
constraint X + Z >= 100;
constraint abs(Y - Z) <= 60;
constraint X >= Z - 10;

% Objective: minimize total cost
var int: total_cost = 50*X + 80*Y + 30*Z;
solve minimize total_cost;

output [
  "X=", show(X), " Y=", show(Y), " Z=", show(Z), "\n",
  "Minimum total cost ($) = ", show(total_cost), "\n"
];