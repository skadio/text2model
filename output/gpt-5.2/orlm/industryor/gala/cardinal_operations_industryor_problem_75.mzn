% Timber purchase / storage / sales planning over 4 quarters
% Maximize annual profit with limited warehouse capacity and time-dependent storage cost.
%
% Data is embedded as requested.

include "globals.mzn";

% ----- Sets / indices -----
int: Q = 4;
set of int: Quarters = 1..Q;
% 1=Winter, 2=Spring, 3=Summer, 4=Autumn

array[Quarters] of string: qname = ["Winter","Spring","Summer","Autumn"];

% ----- Data -----
int: CAP = 200000;  % m^3 maximum storage capacity

% Prices given as (10,000 yuan)/(10,000 m^3) => yuan/m^3 numerically equal to the table value.
array[Quarters] of int: buyPrice  = [410, 430, 460, 450];  % yuan per m^3
array[Quarters] of int: sellPrice = [425, 440, 465, 455];  % yuan per m^3

% Estimated maximum sales volume in (10,000 m^3)
array[Quarters] of int: maxSales_10k = [100, 140, 200, 160];
array[Quarters] of int: maxSales = [maxSales_10k[t] * 10000 | t in Quarters]; % m^3

% Storage cost: (a + b*u) yuan/m^3, where u is storage time in quarters
int: a = 70;
int: b = 100;

% ----- Decision variables -----
% x[t,s] = amount purchased in quarter t and sold in quarter s (t <= s), in m^3
array[Quarters, Quarters] of var 0..CAP: x;

% ----- Structural constraints -----
% Only allow t <= s (no selling before buying)
constraint forall(t in Quarters, s in Quarters where s < t)(x[t,s] = 0);

% Sales limit each quarter
constraint forall(s in Quarters)(
  sum(t in Quarters where t <= s)(x[t,s]) <= maxSales[s]
);

% Inventory capacity between quarters:
% inventory after quarter k = sum_{t<=k, s>k} x[t,s]
constraint forall(k in Quarters)(
  sum(t in Quarters where t <= k, s in Quarters where s > k)(x[t,s]) <= CAP
);

% All inventory sold by end of autumn is enforced by allowing sales only within 1..4,
% and x[t,s]=0 for s<t already; no additional end-inventory variable needed.

% ----- Objective: maximize profit -----
% Profit contribution of x[t,s]:
% revenue = sellPrice[s] * x[t,s]
% purchase cost = buyPrice[t] * x[t,s]
% storage cost: u = s-t quarters held (0 if same quarter), cost per m^3 = a + b*u
% total storage cost = (a + b*(s-t)) * x[t,s]
var int: profit =
  sum(t in Quarters, s in Quarters where t <= s)(
      (sellPrice[s] - buyPrice[t] - (a + b*(s - t))) * x[t,s]
  );

solve maximize profit;

output [
  "Max profit (yuan) = ", show(profit), "\n",
  "Plan x[t,s] = purchase in quarter t sold in quarter s (m^3):\n"
] ++
[
  "  From " ++ qname[t] ++ ": [" ++
  concat([ if s=1 then "" else ", " endif ++ show(x[t,s]) | s in Quarters ]) ++
  "]\n"
  | t in Quarters
] ++
[
  "\nSales by quarter (m^3):\n"
] ++
[
  "  " ++ qname[s] ++ ": " ++
  show(sum(t in Quarters where t <= s)(x[t,s])) ++
  " / " ++ show(maxSales[s]) ++ "\n"
  | s in Quarters
] ++
[
  "\nInventory after each quarter (m^3):\n"
] ++
[
  "  After " ++ qname[k] ++ ": " ++
  show(sum(t in Quarters where t <= k, s in Quarters where s > k)(x[t,s])) ++
  " / " ++ show(CAP) ++ "\n"
  | k in Quarters
];