% Warehouse rental planning over 4 months
% Mixed-Integer Linear Programming formulation in MiniZinc

include "globals.mzn";

int: M = 4;
set of int: Months = 1..M;
set of int: L = 1..4;                % contract lengths (months)

array[Months] of int: demand = [1500, 1000, 2000, 1200];   % sqm required each month

% Rental fee per 100 sqm for a contract of length l
array[L] of int: feePer100 = [4000, 7500, 10500, 13000];

% Convert to fee per 1 sqm (yuan) using exact rational scaling via integer cents is unnecessary;
% here all demands are multiples of 100, so we model area in 100-sqm units.
array[Months] of int: dem100 = [demand[m] div 100 | m in Months];
array[L] of int: fee = feePer100;     % yuan per (100 sqm) for the whole contract

% Start months allowed so that contract covers consecutive months within the horizon
function set of int: Starts(int: l) = 1..(M - l + 1);

% Decision variables:
% x[l,s] = number of contracts of length l starting at month s (each contract is for 100 sqm capacity)
array[L, Months] of var 0..max(dem100): x;

% Restrict invalid starts to 0
constraint forall(l in L, s in Months where s > M - l + 1)( x[l,s] = 0 );

% Demand satisfaction exactly for each month:
% For month m, sum of all contracts that cover m must equal dem100[m]
constraint
  forall(m in Months)(
    sum(l in L, s in Starts(l) where s <= m /\ m <= s + l - 1)( x[l,s] ) = dem100[m]
  );

% "How many contracts of each length are signed" (aggregated across start months)
array[L] of var 0..sum(m in Months)(dem100[m]): nLen;
constraint forall(l in L)(
  nLen[l] = sum(s in Starts(l))( x[l,s] )
);

% Binary indicators whether any contract of length l is used
array[L] of var 0..1: used;
constraint forall(l in L)(
  used[l] <-> (nLen[l] >= 1)
);

% Business rules:
% (2) At least two different contract lengths must be used
constraint sum(l in L)( used[l] ) >= 2;

% (3) If 4-month contract is chosen, then no 1-month contract may be chosen
constraint used[4] = 1 -> used[1] = 0;

% (4) Number of distinct contract lengths used cannot exceed 3
constraint sum(l in L)( used[l] ) <= 3;

% Objective: minimize total cost.
% Each contract of length l starting at s costs fee[l] per (100 sqm) unit times x[l,s].
var int: totalCost =
  sum(l in L, s in Starts(l))( fee[l] * x[l,s] );

solve minimize totalCost;

output [
  "Minimum total rental cost (yuan) = ", show(totalCost), "\n",
  "Contracts by length (count of 100-sqm units over all starts): ", show(nLen), "\n",
  "Used lengths (1..4): ", show(used), "\n",
  "x[l,s] (100-sqm units) by length l and start month s:\n",
  concat([ "l=" ++ show(l) ++ ": " ++ show([x[l,s] | s in Months]) ++ "\n" | l in L ])
];