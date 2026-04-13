include "globals.mzn";

% Production planning July..December (6 months), 2 products, inventory with optional external storage.

% ----------------------------
% Sets / indices
% ----------------------------
int: P = 2;
int: T = 6;
set of int: Products = 1..P;
set of int: Months = 1..T;

% Month names (for output)
array[Months] of string: mname = ["Jul","Aug","Sep","Oct","Nov","Dec"];
array[Products] of string: pname = ["I","II"];

% ----------------------------
% Data (embedded from description)
% ----------------------------

% Demand per month for Jul..Dec
% Product I: Jul-Sep 30k, Oct-Dec 100k
% Product II: Jul-Sep 15k, Oct-Dec 50k
array[Products, Months] of int: demand =
  array2d(Products, Months,
    [
      30000, 30000, 30000, 100000, 100000, 100000,   % Product I
      15000, 15000, 15000,  50000,  50000,  50000    % Product II
    ]);

% Unit production costs (yuan/unit) for Jun..Dec:
% Product I: 4.5 ; Product II: 7
array[Products, Months] of float: prodCost =
  array2d(Products, Months,
    [
      4.5, 4.5, 4.5, 4.5, 4.5, 4.5,   % Product I (Jul-Dec)
      7.0, 7.0, 7.0, 7.0, 7.0, 7.0    % Product II (Jul-Dec)
    ]);

% Combined monthly production capacity (units)
int: capUnits = 120000;

% Volume per unit (m^3/unit)
array[Products] of float: vol = [0.2, 0.4];

% Factory warehouse capacity (m^3)
float: whCap = 15000.0;

% Storage costs (yuan per m^3 per month)
float: costOwn = 1.0;
float: costExt = 1.5;

% Initial inventory at beginning of July is zero
array[Products] of int: initInv = [0, 0];

% ----------------------------
% Decision variables
% ----------------------------

% Production quantity (units)
array[Products, Months] of var 0..capUnits: prod;

% End-of-month inventory (units), after meeting demand in that month
% Upper bound is conservative (total potential production through horizon)
int: maxInv = capUnits * T;  % 720000
array[Products, Months] of var 0..maxInv: inv;

% Storage split (m^3) between own warehouse and external
var 0.0..1.0e9: ownVol;      % total m^3-months in own warehouse (summed over months)
var 0.0..1.0e9: extVol;      % total m^3-months in external warehouse (summed over months)

% Total volume stored each month (m^3)
array[Months] of var 0.0..1.0e9: totVol;

% Objective (yuan)
var float: totalCost;

% ----------------------------
% Constraints
% ----------------------------

% Monthly production capacity
constraint forall(t in Months)(
  sum(p in Products)(prod[p,t]) <= capUnits
);

% Inventory balance:
% inv[p,t] = inv[p,t-1] + prod[p,t] - demand[p,t], with inv >= 0 ensures demand met
constraint forall(p in Products)(
  inv[p,1] = initInv[p] + prod[p,1] - demand[p,1]
);
constraint forall(p in Products, t in 2..T)(
  inv[p,t] = inv[p,t-1] + prod[p,t] - demand[p,t]
);

% Total volume stored each month (end-of-month inventory)
constraint forall(t in Months)(
  totVol[t] = sum(p in Products)(vol[p] * int2float(inv[p,t]))
);

% Split storage each month into own (up to capacity) and external (rest).
% We model aggregated over months using per-month own/external volumes.
array[Months] of var 0.0..1.0e9: ownVol_m;
array[Months] of var 0.0..1.0e9: extVol_m;

constraint forall(t in Months)(
  ownVol_m[t] <= whCap /\
  ownVol_m[t] <= totVol[t] /\
  extVol_m[t] = totVol[t] - ownVol_m[t]
);

constraint ownVol = sum(t in Months)(ownVol_m[t]);
constraint extVol = sum(t in Months)(extVol_m[t]);

% Objective definition: production costs + inventory holding costs (by volume)
constraint totalCost =
  sum(p in Products, t in Months)( prodCost[p,t] * int2float(prod[p,t]) )
  + costOwn * ownVol
  + costExt * extVol;

% ----------------------------
% Solve
% ----------------------------
solve minimize totalCost;

% ----------------------------
% Output
% ----------------------------
output
[
  "Total cost (yuan) = ", show(totalCost), "\n\n",
  "Monthly plan (units):\n",
  concat([ mname[t] ++
           ": Prod I=" ++ show(prod[1,t]) ++
           " Prod II=" ++ show(prod[2,t]) ++
           " | Inv I=" ++ show(inv[1,t]) ++
           " Inv II=" ++ show(inv[2,t]) ++
           " | StoredVol(m3)=" ++ show(totVol[t]) ++
           " Own(m3)=" ++ show(ownVol_m[t]) ++
           " Ext(m3)=" ++ show(extVol_m[t]) ++ "\n"
         | t in Months ]),
  "\nStorage totals (m3-months): Own=", show(ownVol), " Ext=", show(extVol), "\n"
];