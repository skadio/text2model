% Parameters
int: costA = 120;
int: costB = 110;
int: costC = 100;

int: tablesPerOrderA = 20;
int: tablesPerOrderB = 15;
int: tablesPerOrderC = 15;

int: minTables = 150;
int: maxTables = 600;

int: minTablesB_ifA = 30;

% Variables
int: maxOrders = maxTables div min(tablesPerOrderA, min(tablesPerOrderB, tablesPerOrderC));
var 0..maxOrders: ordersA;
var 0..maxOrders: ordersB;
var 0..maxOrders: ordersC;

var minTables..maxTables: totalTables;
var 0..(costA*maxOrders + costB*maxOrders + costC*maxOrders): totalCost;

% Constraints
constraint totalTables =
  tablesPerOrderA * ordersA + tablesPerOrderB * ordersB + tablesPerOrderC * ordersC;

constraint totalCost =
  costA * ordersA + costB * ordersB + costC * ordersC;

% If ordering from A, must order at least 30 tables from B (i.e., at least 2 orders of B = 30 tables)
constraint (ordersA > 0) -> (tablesPerOrderB * ordersB >= minTablesB_ifA);

% If ordering from B, must also order from C
constraint (ordersB > 0) -> (ordersC > 0);

% Objective
solve minimize totalCost;