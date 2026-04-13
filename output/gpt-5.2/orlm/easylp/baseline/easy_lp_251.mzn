% Employee scheduling cost minimization (all data embedded)

int: costX = 8;
int: costY = 6;
int: costZ = 5;

var 0..10: X;  % hours for employee X
var 0..8:  Y;  % hours for employee Y
var 0..6:  Z;  % hours for employee Z

constraint X + Y + Z <= 24;      % total hours limit
constraint X >= Y + 2;           % X at least 2 hours more than Y
constraint Y + Z <= 16;          % shared workspace limit

var int: total_cost = costX * X + costY * Y + costZ * Z;

solve minimize total_cost;

output [
  "X=", show(X), " Y=", show(Y), " Z=", show(Z), "\n",
  "Minimum total cost (rounded) = $", show(total_cost), "\n"
];