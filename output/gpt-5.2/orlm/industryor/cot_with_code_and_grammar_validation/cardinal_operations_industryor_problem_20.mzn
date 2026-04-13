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
var 0..(maxTables div tablesPerOrderA): xA; % number of orders from A
var 0..(maxTables div tablesPerOrderB): xB; % number of orders from B
var 0..(maxTables div tablesPerOrderC): xC; % number of orders from C

var 0..maxTables: totalTables;
var 0..(costA*(maxTables div tablesPerOrderA) + costB*(maxTables div tablesPerOrderB) + costC*(maxTables div tablesPerOrderC)): totalCost;

% Constraints
constraint totalTables =
  tablesPerOrderA * xA + tablesPerOrderB * xB + tablesPerOrderC * xC;

constraint totalTables >= minTables;
constraint totalTables <= maxTables;

constraint totalCost = costA * xA + costB * xB + costC * xC;

% If order from A, must order at least 30 tables from B
constraint (xA > 0) -> (tablesPerOrderB * xB >= minTablesB_ifA);

% If order from B, must also order from C
constraint (xB > 0) -> (xC > 0);

% Objective
solve minimize totalCost;