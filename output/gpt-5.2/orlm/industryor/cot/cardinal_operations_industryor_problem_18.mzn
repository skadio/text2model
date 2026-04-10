% Parameters (with values embedded)
int: costA = 50;
int: costB = 45;
int: costC = 40;

int: chairsPerOrderA = 15;
int: chairsPerOrderB = 10;
int: chairsPerOrderC = 10;

int: minChairs = 100;
int: maxChairs = 500;

% Variables
int: maxOrders = maxChairs div 10; % safe upper bound (smallest lot size is 10)
var 0..maxOrders: ordersA;
var 0..maxOrders: ordersB;
var 0..maxOrders: ordersC;

var bool: useA;
var bool: useB;

var 0..maxChairs: totalChairs;
var 0..(maxChairs * max([costA, costB, costC])): totalCost;

% Constraints
constraint totalChairs = chairsPerOrderA * ordersA + chairsPerOrderB * ordersB + chairsPerOrderC * ordersC;
constraint totalChairs >= minChairs;
constraint totalChairs <= maxChairs;

constraint totalCost = costA * chairsPerOrderA * ordersA
                     + costB * chairsPerOrderB * ordersB
                     + costC * chairsPerOrderC * ordersC;

% Link usage flags to whether any orders are placed
constraint useA <-> (ordersA > 0);
constraint useB <-> (ordersB > 0);

% If ordering from A, must also order at least 10 chairs from B (i.e., at least 1 order from B)
constraint useA -> (ordersB >= 1);

% If ordering from B, must also order from C (at least 1 order from C)
constraint useB -> (ordersC >= 1);

% Objective
solve minimize totalCost;