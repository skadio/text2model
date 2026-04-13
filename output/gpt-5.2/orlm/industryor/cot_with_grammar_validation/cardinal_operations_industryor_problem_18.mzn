% Parameters
int: costA = 50;
int: costB = 45;
int: costC = 40;

int: chairsPerOrderA = 15;
int: chairsPerOrderB = 10;
int: chairsPerOrderC = 10;

int: minChairs = 100;
int: maxChairs = 500;

% Variables
var 0..(maxChairs div chairsPerOrderA + 1): ordersA;
var 0..(maxChairs div chairsPerOrderB + 1): ordersB;
var 0..(maxChairs div chairsPerOrderC + 1): ordersC;

var 0..maxChairs: totalChairs;
var 0..(costA*(maxChairs div chairsPerOrderA + 1)
      + costB*(maxChairs div chairsPerOrderB + 1)
      + costC*(maxChairs div chairsPerOrderC + 1)): totalCost;

% Constraints
constraint totalChairs =
  chairsPerOrderA * ordersA + chairsPerOrderB * ordersB + chairsPerOrderC * ordersC;

constraint totalChairs >= minChairs;
constraint totalChairs <= maxChairs;

constraint totalCost = costA * ordersA + costB * ordersB + costC * ordersC;

% If A is ordered, then at least 10 chairs from B must be ordered (i.e., at least 1 order of B)
constraint ordersA > 0 -> chairsPerOrderB * ordersB >= 10;

% If B is ordered, then C must be ordered
constraint ordersB > 0 -> ordersC > 0;

% Objective
solve minimize totalCost;