% Production planning July-December for two products with inventory and optional external warehouse
% All data embedded.

include "globals.mzn";

int: P = 2;
int: T = 6; % months: Jul..Dec
set of int: Products = 1..P;
set of int: Months = 1..T;

array[Months] of string: monthName = ["Jul","Aug","Sep","Oct","Nov","Dec"];
array[Products] of string: prodName = ["I","II"];

% Demand (units) for Jul..Dec
% Product I: 30k Jul-Sep, 100k Oct-Dec
% Product II: 15k Mar-Sep => 15k Jul-Sep, 50k other months => 50k Oct-Dec
array[Products, Months] of int: demand =
  array2d(Products, Months,
    [
      30000, 30000, 30000, 100000, 100000, 100000,  % Product I
      15000, 15000, 15000,  50000,  50000,  50000   % Product II
    ]);

% Unit production costs (yuan/unit) for Jul..Dec (June-Dec rates)
array[Products, Months] of float: prodCost =
  array2d(Products, Months,
    [
      4.5, 4.5, 4.5, 4.5, 4.5, 4.5,   % Product I
      7.0, 7.0, 7.0, 7.0, 7.0, 7.0    % Product II
    ]);

% Combined production capacity (units/month)
int: capUnits = 120000;

% Volume per unit (m^3/unit)
array[Products] of float: volPerUnit = [0.2, 0.4];

% Warehouse capacity (m^3)
float: whCap = 15000.0;

% Storage costs (yuan per m^3 per month)
float: costOwn = 1.0;
float: costExt = 1.5;

% Initial inventory at beginning of July is zero
array[Products] of int: initInv = [0, 0];

% Decision variables
array[Products, Months] of var int: prod;   % units produced in month t
array[Products, Months] of var int: inv;    % inventory end of month t

% Storage volumes used (m^3) end of each month
array[Months] of var float: invVolume;
array[Months] of var float: ownVolume;
array[Months] of var float: extVolume;

% Domains / bounds
% Upper bound based on capacity; nonnegativity
constraint forall(p in Products, t in Months)(prod[p,t] >= 0 /\ prod[p,t] <= capUnits);
constraint forall(p in Products, t in Months)(inv[p,t] >= 0);

% Monthly production capacity (combined)
constraint forall(t in Months)(
  sum(p in Products)(prod[p,t]) <= capUnits
);

% Inventory balance: inv_end = inv_prev + prod - demand
constraint forall(p in Products, t in Months)(
  inv[p,t] = (if t = 1 then initInv[p] else inv[p,t-1] endif) + prod[p,t] - demand[p,t]
);

% Inventory volume accounting and warehouse split
constraint forall(t in Months)(
  invVolume[t] = sum(p in Products)(volPerUnit[p] * int2float(inv[p,t]))
);

constraint forall(t in Months)(
  ownVolume[t] >= 0.0 /\ extVolume[t] >= 0.0 /\
  ownVolume[t] <= whCap /\
  ownVolume[t] + extVolume[t] = invVolume[t] /\
  extVolume[t] >= invVolume[t] - whCap   % ensures ext covers excess when above capacity
);

% Objective: production cost + inventory holding cost by volume
var float: totalProdCost =
  sum(p in Products, t in Months)(prodCost[p,t] * int2float(prod[p,t]));

var float: totalHoldCost =
  sum(t in Months)(costOwn * ownVolume[t] + costExt * extVolume[t]);

solve minimize totalProdCost + totalHoldCost;

output [
  "Minimum total cost = ", show(totalProdCost + totalHoldCost), "\n",
  "  Production cost  = ", show(totalProdCost), "\n",
  "  Holding cost     = ", show(totalHoldCost), "\n\n",
  "Schedule (units):\n",
  concat([ monthName[t] ++ ":  Prod I=" ++ show(prod[1,t]) ++
           " Prod II=" ++ show(prod[2,t]) ++
           " | EndInv I=" ++ show(inv[1,t]) ++
           " EndInv II=" ++ show(inv[2,t]) ++ "\n"
         | t in Months ]),
  "\nInventory volume & warehousing (m^3):\n",
  concat([ monthName[t] ++ ": InvVol=" ++ show(invVolume[t]) ++
           " Own=" ++ show(ownVolume[t]) ++
           " Ext=" ++ show(extVolume[t]) ++ "\n"
         | t in Months ])
];