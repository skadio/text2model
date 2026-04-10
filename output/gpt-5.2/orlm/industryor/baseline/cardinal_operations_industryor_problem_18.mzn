% Furniture store ordering problem (all data embedded)

% Decision variables: number of orders from each manufacturer (integer, nonnegative)
var 0..1000: ordersA;
var 0..1000: ordersB;
var 0..1000: ordersC;

% Parameters
int: costA = 50;
int: costB = 45;
int: costC = 40;

int: chairsPerOrderA = 15;
int: chairsPerOrderB = 10;
int: chairsPerOrderC = 10;

int: minChairs = 100;
int: maxChairs = 500;

% Total chairs ordered
var 0..100000: totalChairs =
  chairsPerOrderA * ordersA + chairsPerOrderB * ordersB + chairsPerOrderC * ordersC;

constraint totalChairs >= minChairs;
constraint totalChairs <= maxChairs;

% If ordering from A, must order at least 10 chairs from B => at least 1 order of B (10 chairs/order)
constraint (ordersA > 0) -> (ordersB >= 1);

% If ordering from B, must also order from C
constraint (ordersB > 0) -> (ordersC >= 1);

% Objective: minimize total cost
var int: totalCost = costA * ordersA + costB * ordersB + costC * ordersC;

solve minimize totalCost;

output [
  "ordersA=", show(ordersA), "\n",
  "ordersB=", show(ordersB), "\n",
  "ordersC=", show(ordersC), "\n",
  "totalChairs=", show(totalChairs), "\n",
  "totalCost=", show(totalCost), "\n"
];