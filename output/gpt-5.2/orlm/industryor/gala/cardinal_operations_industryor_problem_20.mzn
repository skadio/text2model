include "globals.mzn";

/* Data (embedded) */
int: costA = 120;
int: costB = 110;
int: costC = 100;

int: tablesPerOrderA = 20;
int: tablesPerOrderB = 15;
int: tablesPerOrderC = 15;

int: minTables = 150;
int: maxTables = 600;

/* Decision variables: number of orders from each supplier */
var 0..ceil(maxTables div min(tablesPerOrderA, min(tablesPerOrderB, tablesPerOrderC))): oA;
var 0..ceil(maxTables div min(tablesPerOrderA, min(tablesPerOrderB, tablesPerOrderC))): oB;
var 0..ceil(maxTables div min(tablesPerOrderA, min(tablesPerOrderB, tablesPerOrderC))): oC;

/* Derived totals */
var 0..maxTables: totalTables = tablesPerOrderA * oA + tablesPerOrderB * oB + tablesPerOrderC * oC;
var int: totalCost = costA * oA + costB * oB + costC * oC;

/* Core requirements */
constraint totalTables >= minTables;
constraint totalTables <= maxTables;

/* Logical constraints */
% If ordering from A, then at least 30 tables from B (i.e., at least 2 orders of B since 2*15=30)
constraint (oA > 0) -> (tablesPerOrderB * oB >= 30);

% If ordering from B, then must also order from C
constraint (oB > 0) -> (oC > 0);

/* Solve: minimize total cost */
solve minimize totalCost;

/* Output */
output [
  "Orders A = ", show(oA), "\n",
  "Orders B = ", show(oB), "\n",
  "Orders C = ", show(oC), "\n",
  "Total tables = ", show(totalTables), "\n",
  "Total cost = $", show(totalCost), "\n"
];