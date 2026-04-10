% Parameters
% Costs per chair
int: costA = 50;
int: costB = 45;
int: costC = 40;

% Chairs per order
int: chairsPerOrderA = 15;
int: chairsPerOrderB = 10;
int: chairsPerOrderC = 10;

% Total chairs requirement bounds
int: minTotalChairs = 100;
int: maxTotalChairs = 500;

% Implication-related minimums
int: minChairsB_if_A = 10;  % if ordering from A, must order at least 10 chairs from B


% Variables
% Number of orders placed with each manufacturer (non-negative integers)
var 0..(maxTotalChairs div chairsPerOrderA + 1): ordersA;
var 0..(maxTotalChairs div chairsPerOrderB + 1): ordersB;
var 0..(maxTotalChairs div chairsPerOrderC + 1): ordersC;

% Whether we order from each manufacturer
var bool: useA;
var bool: useB;
var bool: useC;

% Derived totals (bounded for linearity clarity)
var 0..maxTotalChairs: totalChairs;
var 0..(maxTotalChairs * max(costA, max(costB, costC))): totalCost;


% Constraints
% Link usage booleans to whether any orders are placed
constraint useA <-> (ordersA > 0);
constraint useB <-> (ordersB > 0);
constraint useC <-> (ordersC > 0);

% Total chairs calculation from orders
constraint
  totalChairs
  = chairsPerOrderA * ordersA
  + chairsPerOrderB * ordersB
  + chairsPerOrderC * ordersC;

% Total chairs bounds (at least and at most required)
constraint totalChairs >= minTotalChairs;
constraint totalChairs <= maxTotalChairs;

% Total cost calculation (cost per chair * chairs ordered from each manufacturer)
constraint
  totalCost
  = costA * chairsPerOrderA * ordersA
  + costB * chairsPerOrderB * ordersB
  + costC * chairsPerOrderC * ordersC;

% Implication: if ordering from A, must order at least minChairsB_if_A chairs from B
constraint useA -> (chairsPerOrderB * ordersB >= minChairsB_if_A);

% Implication: if ordering from B, must also order from C
constraint useB -> useC;


% Objective
solve minimize totalCost;