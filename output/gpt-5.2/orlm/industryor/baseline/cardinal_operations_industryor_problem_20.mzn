% Dining tables procurement from suppliers A, B, C

int: costA = 120;
int: costB = 110;
int: costC = 100;

int: tablesPerOrderA = 20;
int: tablesPerOrderB = 15;
int: tablesPerOrderC = 15;

int: minTables = 150;
int: maxTables = 600;

% Decision variables: number of orders from each supplier (integers)
var 0..(maxTables div tablesPerOrderA + 5): ordA;
var 0..(maxTables div tablesPerOrderB + 5): ordB;
var 0..(maxTables div tablesPerOrderC + 5): ordC;

% Total tables ordered
var 0..maxTables: totalTables =
    tablesPerOrderA * ordA + tablesPerOrderB * ordB + tablesPerOrderC * ordC;

constraint totalTables >= minTables;
constraint totalTables <= maxTables;

% Logical constraints
% If order from A, then at least 30 tables from B (i.e., at least 2 orders of B since 2*15=30)
constraint (ordA > 0) -> (tablesPerOrderB * ordB >= 30);

% If order from B, then also order from C
constraint (ordB > 0) -> (ordC > 0);

% Objective: minimize total cost
var int: totalCost = costA * ordA + costB * ordB + costC * ordC;
solve minimize totalCost;

output [
  "Orders A: ", show(ordA), "\n",
  "Orders B: ", show(ordB), "\n",
  "Orders C: ", show(ordC), "\n",
  "Total tables: ", show(totalTables), "\n",
  "Total cost: $", show(totalCost), "\n"
];