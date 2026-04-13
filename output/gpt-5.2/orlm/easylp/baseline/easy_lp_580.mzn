% Resource allocation: residential (X), commercial (Y), industrial (Z)
% Minimize total cost subject to constraints.

int: max_resources = 1000;

int: cost_X = 200;
int: cost_Y = 150;
int: cost_Z = 300;

var 0..max_resources: X;
var 0..max_resources: Y;
var 0..max_resources: Z;

constraint X + Y + Z <= max_resources;

% Residential exceeds commercial by at least 50
constraint X >= Y + 50;

% Industrial and residential differ by no more than 200
constraint abs(Z - X) <= 200;

% Commercial at least 30 more than industrial
constraint Y >= Z + 30;

var int: total_cost = cost_X * X + cost_Y * Y + cost_Z * Z;

solve minimize total_cost;

output [
  "X(residential) = ", show(X), "\n",
  "Y(commercial)  = ", show(Y), "\n",
  "Z(industrial)  = ", show(Z), "\n",
  "Total cost ($) = ", show(total_cost), "\n"
];