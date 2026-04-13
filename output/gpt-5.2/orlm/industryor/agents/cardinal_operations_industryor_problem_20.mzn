% Parameters
int: costA = 120;              % Cost per order from Supplier A
int: costB = 110;              % Cost per order from Supplier B
int: costC = 100;              % Cost per order from Supplier C

int: tablesPerOrderA = 20;     % Tables included in one order from A
int: tablesPerOrderB = 15;     % Tables included in one order from B
int: tablesPerOrderC = 15;     % Tables included in one order from C

int: minTotalTables = 150;     % Minimum total tables required
int: maxTotalTables = 600;     % Maximum total tables allowed

int: minTablesB_ifA = 30;      % If ordering from A, must order at least this many tables from B


% Variables
var 0..(maxTotalTables div tablesPerOrderA): ordersA;  % Integer number of orders from A
var 0..(maxTotalTables div tablesPerOrderB): ordersB;  % Integer number of orders from B
var 0..(maxTotalTables div tablesPerOrderC): ordersC;  % Integer number of orders from C

var 0..maxTotalTables: tablesA;      % Total tables ordered from A
var 0..maxTotalTables: tablesB;      % Total tables ordered from B
var 0..maxTotalTables: tablesC;      % Total tables ordered from C
var 0..maxTotalTables: totalTables;  % Total tables ordered overall

var 0..(maxTotalTables * max([costA, costB, costC])): totalCost; % Total cost to minimize

var bool: useA;  % True iff ordering any tables from A
var bool: useB;  % True iff ordering any tables from B
var bool: useC;  % True iff ordering any tables from C


% Constraints
% Link orders to number of tables from each supplier
constraint tablesA = ordersA * tablesPerOrderA;
constraint tablesB = ordersB * tablesPerOrderB;
constraint tablesC = ordersC * tablesPerOrderC;

% Compute total number of tables ordered
constraint totalTables = tablesA + tablesB + tablesC;

% Enforce minimum and maximum total tables required
constraint totalTables >= minTotalTables;
constraint totalTables <= maxTotalTables;

% Compute total cost
constraint totalCost = costA * ordersA + costB * ordersB + costC * ordersC;

% Define usage booleans based on whether any orders are placed
constraint useA <-> (ordersA > 0);
constraint useB <-> (ordersB > 0);
constraint useC <-> (ordersC > 0);

% If ordering from A, must order at least minTablesB_ifA tables from B
constraint useA -> (tablesB >= minTablesB_ifA);

% If ordering from B, must also order from C
constraint useB -> useC;


% Objective
solve minimize totalCost;