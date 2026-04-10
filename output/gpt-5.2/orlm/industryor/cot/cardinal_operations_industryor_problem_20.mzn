% Parameters (with values embedded)
int: costA = 120;
int: costB = 110;
int: costC = 100;

int: tablesPerOrderA = 20;
int: tablesPerOrderB = 15;
int: tablesPerOrderC = 15;

int: minTables = 150;
int: maxTables = 600;

int: minTablesB_ifA = 30;

% Upper bounds on number of orders from max tables
int: maxOrdersA = maxTables div tablesPerOrderA; % 600/20 = 30
int: maxOrdersB = maxTables div tablesPerOrderB; % 600/15 = 40
int: maxOrdersC = maxTables div tablesPerOrderC; % 600/15 = 40

% Variables
var 0..maxOrdersA: ordersA;
var 0..maxOrdersB: ordersB;
var 0..maxOrdersC: ordersC;

% Helper binary indicators for implication constraints
var 0..1: useA;
var 0..1: useB;
var 0..1: useC;

var 0..maxTables: totalTables;

% Constraints
constraint totalTables =
  tablesPerOrderA * ordersA + tablesPerOrderB * ordersB + tablesPerOrderC * ordersC;

constraint totalTables >= minTables;
constraint totalTables <= maxTables;

% Link useX with whether ordersX is positive
constraint ordersA <= maxOrdersA * useA;
constraint ordersA >= useA;

constraint ordersB <= maxOrdersB * useB;
constraint ordersB >= useB;

constraint ordersC <= maxOrdersC * useC;
constraint ordersC >= useC;

% If order from A, must also order at least 30 tables from B (i.e., ordersB*15 >= 30 => ordersB >= 2)
constraint tablesPerOrderB * ordersB >= minTablesB_ifA * useA;

% If order from B, must also order from C
constraint useB <= useC;

% Objective
solve minimize costA * ordersA + costB * ordersB + costC * ordersC;