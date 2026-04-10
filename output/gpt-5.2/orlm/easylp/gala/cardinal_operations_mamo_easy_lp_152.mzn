% Shipping containers: minimize total cost subject to capacity and minimums.

int: costX = 50;
int: costY = 70;

int: maxTotal = 1000;
int: minX = 300;
int: minY = 200;

/* Decision variables: number of containers shipped of each type (integers) */
var minX..maxTotal: x;   % type X containers
var minY..maxTotal: y;   % type Y containers

/* Capacity constraint */
constraint x + y <= maxTotal;

/* Objective: total cost in dollars */
var int: totalCost = costX * x + costY * y;

solve minimize totalCost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "totalCost = $", show(totalCost), "\n"
];