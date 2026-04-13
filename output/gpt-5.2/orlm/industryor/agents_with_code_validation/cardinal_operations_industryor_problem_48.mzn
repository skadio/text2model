% Parameters
int: nMonths = 4;                              % Planning horizon (months)
set of int: MONTHS = 1..nMonths;

int: nTypes = 4;                               % Contract length types (1..4 months)
set of int: TYPES = 1..nTypes;                 % Type t corresponds to length t months

array[MONTHS] of int: demand = [1500, 1000, 2000, 1200];         % Required area each month (m^2)
array[TYPES] of int: feePer100 = [4000, 7500, 10500, 13000];     % Rental fee per 100 m^2 for length t (yuan)

int: unitArea = 100;                           % Pricing unit area (m^2)

% Variables
% x[t,m]: area (in units of 100 m^2) started in month m with contract length t
% Only meaningful for starts that fit in horizon: m <= nMonths - t + 1
array[TYPES, MONTHS] of var 0..200: x;          % upper bound is a safe Big-M upper bound

% y[t,m]: whether any contract of length t starting at month m is used
array[TYPES, MONTHS] of var bool: y;

% usedLen[t]: whether any contract of length t is used anywhere in the horizon
array[TYPES] of var bool: usedLen;

% Count of distinct contract lengths used (must be between 2 and 3 by rules)
var 0..nTypes: numDistinctLengths;

% Total cost (yuan)
var 0..1000000000: totalCost;

% Constraints
% --- Structural constraints for invalid start months (t cannot start too late) ---
constraint
  forall(t in TYPES, m in MONTHS where m > nMonths - t + 1) (
    x[t,m] = 0 /\ y[t,m] = false
  );

% --- Link x and y (if any area rented under a (t,m) contract, then y[t,m]=1) ---
% Big-M: safe upper bound in units of 100m^2.
constraint
  forall(t in TYPES, m in MONTHS where m <= nMonths - t + 1) (
    x[t,m] <= 200 * bool2int(y[t,m])
  );

% --- Link usedLen to y across start months ---
constraint
  forall(t in TYPES) (
    usedLen[t] <-> (exists(m in MONTHS where m <= nMonths - t + 1)(y[t,m]))
  );

% --- Demand satisfaction exactly (no shortage, no excess) for each month ---
% Sum of all contracts (t,m0) that cover month m: m0 <= m <= m0+t-1
constraint
  forall(m in MONTHS) (
    sum(t in TYPES, m0 in MONTHS where m0 <= nMonths - t + 1 /\ m0 <= m /\ m <= m0 + t - 1) (
      x[t,m0] * unitArea
    ) = demand[m]
  );

% --- Business rule: at least two different contract lengths must be used ---
constraint
  sum(t in TYPES)(bool2int(usedLen[t])) >= 2;

% --- Business rule: mutual exclusion between 1-month and 4-month contracts ---
constraint
  bool2int(usedLen[4]) + bool2int(usedLen[1]) <= 1;

% --- Business rule: number of distinct contract lengths used cannot exceed 3 ---
constraint
  sum(t in TYPES)(bool2int(usedLen[t])) <= 3;

% --- Count distinct lengths (for reporting/inspection) ---
constraint
  numDistinctLengths = sum(t in TYPES)(bool2int(usedLen[t]));

% --- Define total cost (yuan) ---
% Each x[t,m] is in units of 100 m^2; cost is feePer100[t] per unit.
constraint
  totalCost = sum(t in TYPES, m in MONTHS where m <= nMonths - t + 1) (
    x[t,m] * feePer100[t]
  );

% Objective
solve minimize totalCost;