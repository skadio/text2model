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
var 0..ceil(maxChairs div chairsPerOrderA)+maxChairs: ordersA;
var 0..ceil(maxChairs div chairsPerOrderB)+maxChairs: ordersB;
var 0..ceil(maxChairs div chairsPerOrderC)+maxChairs: ordersC;

var 0..maxChairs: totalChairs;
var 0..(costA*maxChairs + costB*maxChairs + costC*maxChairs): totalCost;

var bool: useA;
var bool: useB;

% Constraints
constraint totalChairs = chairsPerOrderA * ordersA + chairsPerOrderB * ordersB + chairsPerOrderC * ordersC;
constraint totalChairs >= minChairs;
constraint totalChairs <= maxChairs;

constraint totalCost = costA * ordersA + costB * ordersB + costC * ordersC;

% Linking "use" booleans to whether orders are positive
constraint ordersA >= 1 <-> useA;
constraint ordersB >= 1 <-> useB;

% If ordering from A, must order at least 10 chairs from B (i.e., at least 1 order of B)
constraint useA -> (chairsPerOrderB * ordersB >= 10);

% If ordering from B, must also order from C (at least 1 order of C)
constraint useB -> (ordersC >= 1);

% Objective
solve minimize totalCost;