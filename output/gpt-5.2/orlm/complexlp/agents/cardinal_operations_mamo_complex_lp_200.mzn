% Parameters
int: nMonths = 6;                           % planning horizon length
set of int: MONTHS = 1..nMonths;            % month index set (1=Jan,...,6=Jun)

array[MONTHS] of int: demand =              % monthly demand
  [430, 430, 380, 450, 520, 440];

int: initInventory = 10;                    % inventory at end of Dec / start of Jan

int: regCap = 420;                          % regular-time monthly capacity
int: otCap  = 80;                           % overtime monthly capacity

int: regCost = 40;                          % cost per wrench (regular-time)
int: otCost  = 45;                          % cost per wrench (overtime)
int: holdCost = 3;                          % holding cost per wrench per month

% Useful derived bounds
int: maxInv = initInventory + sum(demand);  % safe upper bound on inventory
int: maxProd = regCap + otCap;              % max total production per month (unused but kept)

% Variables
array[MONTHS] of var 0..regCap: regProd;    % regular-time production in each month
array[MONTHS] of var 0..otCap:  otProd;     % overtime production in each month

array[MONTHS] of var 0..maxInv: invEnd;     % inventory at end of each month

var 0..(regCost*regCap*nMonths + otCost*otCap*nMonths + holdCost*maxInv*nMonths): totalCost;
                                            % total cost to be minimized

% Constraints

% --- Capacity constraints (already enforced by variable domains, kept for clarity) ---
constraint
  forall(m in MONTHS) (
    regProd[m] >= 0 /\ regProd[m] <= regCap
  );

constraint
  forall(m in MONTHS) (
    otProd[m] >= 0 /\ otProd[m] <= otCap
  );

% --- Inventory flow balance: satisfy demand each month ---
% invEnd[m] = inventory at end of month m after producing and meeting demand.
constraint
  invEnd[1] = initInventory + regProd[1] + otProd[1] - demand[1];

constraint
  forall(m in 2..nMonths) (
    invEnd[m] = invEnd[m-1] + regProd[m] + otProd[m] - demand[m]
  );

% --- Feasibility: demand must be met (nonnegative ending inventory each month) ---
% Ensured by invEnd domain 0..maxInv, kept explicitly for clarity.
constraint
  forall(m in MONTHS) (
    invEnd[m] >= 0
  );

% --- Total cost accounting (production + holding) ---
% Holding cost is charged per wrench per month on end-of-month inventory.
constraint
  totalCost =
    sum(m in MONTHS) (regCost * regProd[m] + otCost * otProd[m] + holdCost * invEnd[m]);

% Objective
solve minimize totalCost;