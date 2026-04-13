% Production & inventory planning (July..December), 2 products
% Minimize production cost + storage cost (own warehouse + external rental)

include "globals.mzn";

%----------------------------
% Sets and indices
%----------------------------
int: nMonths = 6;                 % Jul..Dec
set of int: MONTHS = 1..nMonths;

int: nProducts = 2;               % 1=Product I, 2=Product II
set of int: PRODUCTS = 1..nProducts;

array[MONTHS] of string: monthName = ["Jul","Aug","Sep","Oct","Nov","Dec"];

%----------------------------
% Data (embedded)
%----------------------------
% Demand (units) for each product in each month (Jul..Dec)
array[PRODUCTS, MONTHS] of int: demand = array2d(PRODUCTS, MONTHS,
[
  30000, 30000, 30000, 100000, 100000, 100000,   % Product I
  15000, 15000, 15000,  50000,  50000,  50000    % Product II
]);

% To avoid floating-point linear limitations in some solvers, scale money by 10.
% Production costs (yuan/unit):
% Jun..Dec: Product I=4.5, Product II=7.0  => scaled by 10: 45, 70
array[PRODUCTS, MONTHS] of int: prodCost10 = array2d(PRODUCTS, MONTHS,
[
  45, 45, 45, 45, 45, 45,     % Product I
  70, 70, 70, 70, 70, 70      % Product II
]);

int: monthlyProdCap = 120000;     % combined capacity (units/month)

% Volumes (m^3/unit). Use scaling by 10: 0.2->2/10, 0.4->4/10.
array[PRODUCTS] of int: volNum = [2, 4];
int: volDen = 10;

int: ownWarehouseCap_m3 = 15000;  % m^3

% Storage costs (yuan/m^3/month): own=1.0, external=1.5
% scaled by 10: own=10, ext=15
int: ownStorageCost10 = 10;
int: extStorageCost10 = 15;

array[PRODUCTS] of int: initInv = [0, 0];  % initial inventory at beginning of July

%----------------------------
% Variable bounds (integers only)
%----------------------------
% A safe upper bound for inventory in units: at most total demand over horizon.
array[PRODUCTS] of int: maxInv = [
  sum(t in MONTHS)(demand[1,t]),   % Product I: 390000
  sum(t in MONTHS)(demand[2,t])    % Product II: 195000
];

array[PRODUCTS, MONTHS] of var 0..monthlyProdCap: prod;              % units
array[PRODUCTS, MONTHS] of var 0..max(maxInv): inv;                  % units (end-of-month)

% Inventory volume split in m^3, all integer m^3.
% Upper bound for volume: compute from maxInv with conservative rounding.
int: maxVol_m3 =
  (volNum[1]*maxInv[1] + volNum[2]*maxInv[2] + (volDen-1)) div volDen;

array[MONTHS] of var 0..maxVol_m3: invVol_m3;   % total inventory volume (m^3)
array[MONTHS] of var 0..ownWarehouseCap_m3: ownVol_m3;
array[MONTHS] of var 0..maxVol_m3: extVol_m3;

% Total costs scaled by 10 (tenths of yuan)
var 0..int_max: totalProdCost10;
var 0..int_max: totalInvCost10;
var 0..int_max: totalCost10;

%----------------------------
% Constraints
%----------------------------

% Monthly production capacity
constraint forall(t in MONTHS) (
  sum(p in PRODUCTS)(prod[p,t]) <= monthlyProdCap
);

% Inventory balance
constraint forall(p in PRODUCTS) (
  inv[p,1] = initInv[p] + prod[p,1] - demand[p,1]
);
constraint forall(p in PRODUCTS, t in 2..nMonths) (
  inv[p,t] = inv[p,t-1] + prod[p,t] - demand[p,t]
);

% Inventory volume (m^3): invVol = (2*inv1 + 4*inv2) / 10, must be integer m^3.
% Use exact integer divisibility to avoid floating-point constraints.
constraint forall(t in MONTHS) (
  volDen * invVol_m3[t] =
    sum(p in PRODUCTS)(volNum[p] * inv[p,t])
);

% Warehouse split
constraint forall(t in MONTHS) (
  ownVol_m3[t] + extVol_m3[t] = invVol_m3[t] /\
  ownVol_m3[t] <= ownWarehouseCap_m3
);

% Strengthening: if external is used, own warehouse is full
constraint forall(t in MONTHS) (
  (extVol_m3[t] > 0) -> (ownVol_m3[t] = ownWarehouseCap_m3)
);

% Costs (all integer, scaled by 10)
constraint totalProdCost10 =
  sum(p in PRODUCTS, t in MONTHS)(prodCost10[p,t] * prod[p,t]);

constraint totalInvCost10 =
  sum(t in MONTHS)(ownStorageCost10 * ownVol_m3[t] + extStorageCost10 * extVol_m3[t]);

constraint totalCost10 = totalProdCost10 + totalInvCost10;

%----------------------------
% Objective
%----------------------------
solve minimize totalCost10;

%----------------------------
% Output
%----------------------------
output [
  "Total cost (yuan) = ", show(totalCost10 / 10.0), "\n",
  "Production plan (units):\n"
] ++
[
  monthName[t] ++
  ": P1=" ++ show(prod[1,t]) ++
  " P2=" ++ show(prod[2,t]) ++
  " | InvEnd: I1=" ++ show(inv[1,t]) ++
  " I2=" ++ show(inv[2,t]) ++
  " | Vol(m3)=" ++ show(invVol_m3[t]) ++
  " (own=" ++ show(ownVol_m3[t]) ++ ", ext=" ++ show(extVol_m3[t]) ++ ")\n"
  | t in MONTHS
];