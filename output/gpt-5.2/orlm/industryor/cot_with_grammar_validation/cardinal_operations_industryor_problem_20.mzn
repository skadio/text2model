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
var 0..(maxTables div tablesPerOrderA): ordersA;
var 0..(maxTables div tablesPerOrderB): ordersB;
var 0..(maxTables div tablesPerOrderC): ordersC;

var 0..maxTables: totalTables;
var 0..(costA*(maxTables div tablesPerOrderA) + costB*(maxTables div tablesPerOrderB) + costC*(maxTables div tablesPerOrderC)): totalCost;

var bool: useA;
var bool: useB;
var bool: useC;

% Constraints
constraint totalTables =
  tablesPerOrderA*ordersA + tablesPerOrderB*ordersB + tablesPerOrderC*ordersC;

constraint totalTables >= minTables;
constraint totalTables <= maxTables;

constraint totalCost = costA*ordersA + costB*ordersB + costC*ordersC;

constraint useA <-> (ordersA >= 1);
constraint useB <-> (ordersB >= 1);
constraint useC <-> (ordersC >= 1);

constraint useA -> (tablesPerOrderB*ordersB >= minTablesB_ifA);
constraint useB -> useC;

% Objective
solve minimize totalCost;