% Parameters
int: T = 4;
set of int: Months = 1..T;

set of int: L = 1..4; % contract lengths (months)

array[Months] of int: demand = [1500, 1000, 2000, 1200]; % sqm required each month

% rental fee per 100 sqm for each contract length
array[L] of int: fee_per_100 = [4000, 7500, 10500, 13000];

% Convert fees to per-sqm and keep integrality by modeling in units of 100 sqm
% (all demands are multiples of 100 sqm)
int: U = 100; % sqm per unit
array[Months] of int: demand_u = [demand[t] div U | t in Months]; % units of 100 sqm
array[L] of int: fee_u = fee_per_100; % yuan per unit (100 sqm) for a contract of length l

% Upper bound on how many 100-sqm units could ever be contracted (safe big-M)
int: max_demand_u = max(t in Months)(demand_u[t]);
int: BigM = max_demand_u; % per length/contract-start bound

set of int: StartMonths = 1..T;

% Variables
% x[s,l] = number of 100-sqm units contracted starting at month s for length l
array[StartMonths, L] of var 0..BigM: x;

% y[l] = 1 if any contract of length l is used, else 0
array[L] of var 0..1: y;

var int: total_cost;

% Constraints
% Disallow contracts that would extend past month 4
constraint
  forall(s in StartMonths, l in L where s + l - 1 > T) (
    x[s,l] = 0
  );

% Meet demand exactly each month (no shortage, no excess)
constraint
  forall(t in Months) (
    sum(s in StartMonths, l in L where s <= t /\ t <= s + l - 1)(x[s,l]) = demand_u[t]
  );

% Link usage binaries to existence of any contract of that length
constraint
  forall(l in L) (
    sum(s in StartMonths)(x[s,l]) <= BigM * y[l]
  );

constraint
  forall(l in L) (
    sum(s in StartMonths)(x[s,l]) >= y[l]
  );

% At least two different contract lengths must be used
constraint
  sum(l in L)(y[l]) >= 2;

% If 4-month contract is used, no 1-month contract may be used
constraint
  y[4] + y[1] <= 1;

% Number of distinct contract lengths used cannot exceed 3
constraint
  sum(l in L)(y[l]) <= 3;

% Total cost (yuan): each x[s,l] is in 100-sqm units, fee_u is yuan per 100 sqm
constraint
  total_cost = sum(s in StartMonths, l in L)(x[s,l] * fee_u[l]);

% Objective
solve minimize total_cost;