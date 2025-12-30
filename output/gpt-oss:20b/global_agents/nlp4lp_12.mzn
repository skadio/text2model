% Inventory‑planning with production and storage costs
include "globals.mzn";

%--- Input data ----------------------------------------------------------
int: T;                           % number of periods
array[1..T] of int: Deliver;      % demand in each period
int: StorageCost;                 % cost per unit per period of holding
int: SwitchCost;                  % cost per unit of changing production level

%--- Derived values ------------------------------------------------------
int: maxProd = sum(Deliver);      % upper bound on production in any period

%--- Decision variables --------------------------------------------------
array[1..T] of var 0..maxProd: x;            % production in period i
array[0..T] of var 0..maxProd: inv;          % inventory at end of period i
                                      %   inv[0] = 0 (start of year)

%--- Constraints ---------------------------------------------------------
constraint inv[0] = 0;
constraint
  forall(i in 1..T)(
    x[i] + inv[i-1] == Deliver[i] + inv[i]
  );

%--- Objective ----------------------------------------------------------
var int: storageCostTotal =
        sum(i in 1..T-1)( StorageCost * inv[i] );   % no cost for inv[T]

var int: switchCostTotal =
        sum(i in 2..T)( SwitchCost * abs(x[i] - x[i-1]) );

var int: totalCost = storageCostTotal + switchCostTotal;

solve minimize totalCost;

%--- Output -------------------------------------------------------------
output [
  "Production schedule:\n", show(x), "\n",
  "Inventory at period end:\n", show(inv[1..T]), "\n",
  "Total cost: ", show(totalCost), "\n"
];