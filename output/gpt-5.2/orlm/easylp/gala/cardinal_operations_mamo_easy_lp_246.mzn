% Employee scheduling / staffing cost minimization
% Data embedded as requested.

int: maxTotal = 24;

int: minX = 4;   % morning
int: minY = 6;   % afternoon
int: minZ = 5;   % night

int: costX = 8;  % $/hour per employee
int: costY = 6;
int: costZ = 5;

% Decision variables: whole number of employees per shift
var 0..maxTotal: X;
var 0..maxTotal: Y;
var 0..maxTotal: Z;

constraint X >= minX;
constraint Y >= minY;
constraint Z >= minZ;
constraint X + Y + Z <= maxTotal;

var int: totalCost = costX * X + costY * Y + costZ * Z;

solve minimize totalCost;

output [
  "X(morning) = ", show(X), "\n",
  "Y(afternoon) = ", show(Y), "\n",
  "Z(night) = ", show(Z), "\n",
  "Minimum total labor cost ($/hour) = ", show(totalCost), "\n"
];