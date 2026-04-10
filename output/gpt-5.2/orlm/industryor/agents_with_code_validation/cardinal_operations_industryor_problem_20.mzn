% Parameters
% Costs per order (USD)
int: costA = 120;
int: costB = 110;
int: costC = 100;

% Tables per order from each supplier
int: tablesPerOrderA = 20;
int: tablesPerOrderB = 15;
int: tablesPerOrderC = 15;

% Demand bounds (tables)
int: minTables = 150;
int: maxTables = 600;

% Linking requirements (tables)
int: minBTablesIfAUsed = 30;

% Derived bounds for decision variables (orders)
int: maxOrdersA = maxTables div tablesPerOrderA; % 600/20 = 30
int: maxOrdersB = maxTables div tablesPerOrderB; % 600/15 = 40
int: maxOrdersC = maxTables div tablesPerOrderC; % 600/15 = 40


% Variables
% Number of orders placed with each supplier (integer, bounded)
var 0..maxOrdersA: ordersA;
var 0..maxOrdersB: ordersB;
var 0..maxOrdersC: ordersC;

% Whether each supplier is used (for implication constraints)
var bool: useA;
var bool: useB;
var bool: useC;

% Total number of tables ordered (bounded)
var minTables..maxTables: totalTables;

% Total cost (bounded with safe upper bound)
var 0..(costA*maxOrdersA + costB*maxOrdersB + costC*maxOrdersC): totalCost;


% Constraints
% --- Define total tables ordered from the number of orders ---
constraint
  totalTables =
    tablesPerOrderA * ordersA +
    tablesPerOrderB * ordersB +
    tablesPerOrderC * ordersC;

% --- Enforce demand bounds explicitly (also consistent with totalTables domain) ---
constraint totalTables >= minTables;
constraint totalTables <= maxTables;

% --- Define total cost from the number of orders ---
constraint
  totalCost =
    costA * ordersA +
    costB * ordersB +
    costC * ordersC;

% --- Link "use" booleans to whether orders are placed (reified equivalence) ---
constraint useA <-> (ordersA > 0);
constraint useB <-> (ordersB > 0);
constraint useC <-> (ordersC > 0);

% --- Supplier dependency constraints ---
% If supplier A is used, must order at least minBTablesIfAUsed tables from B
constraint
  useA -> (tablesPerOrderB * ordersB >= minBTablesIfAUsed);

% If supplier B is used, supplier C must also be used
constraint
  useB -> useC;


% Objective
solve minimize totalCost;