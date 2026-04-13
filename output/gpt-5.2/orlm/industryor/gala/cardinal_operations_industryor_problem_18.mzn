include "globals.mzn";

% Data (embedded)
int: costA = 50;
int: costB = 45;
int: costC = 40;

int: sizeA = 15;   % chairs per order from A
int: sizeB = 10;   % chairs per order from B
int: sizeC = 10;   % chairs per order from C

int: minChairs = 100;
int: maxChairs = 500;

% Decision variables: number of orders (integers)
var 0..(maxChairs div sizeA + 1): ordA;
var 0..(maxChairs div sizeB + 1): ordB;
var 0..(maxChairs div sizeC + 1): ordC;

% Derived quantities
var 0..10000: chairsA = sizeA * ordA;
var 0..10000: chairsB = sizeB * ordB;
var 0..10000: chairsC = sizeC * ordC;

var 0..1000000: totalCost = costA * chairsA + costB * chairsB + costC * chairsC;
var 0..10000: totalChairs = chairsA + chairsB + chairsC;

% Constraints: total chairs bounds
constraint totalChairs >= minChairs;
constraint totalChairs <= maxChairs;

% Logical constraints
% If order from A, must order at least 10 chairs from B (i.e., at least 1 order of B)
constraint (ordA > 0) -> (chairsB >= 10);

% If order from B, must also order from C (at least 1 order of C)
constraint (ordB > 0) -> (ordC > 0);

solve minimize totalCost;

output [
  "ordA=", show(ordA), " (chairsA=", show(chairsA), ")\n",
  "ordB=", show(ordB), " (chairsB=", show(chairsB), ")\n",
  "ordC=", show(ordC), " (chairsC=", show(chairsC), ")\n",
  "totalChairs=", show(totalChairs), "\n",
  "totalCost=", show(totalCost), "\n"
];