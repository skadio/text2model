include "globals.mzn";

int: I;
int: M;

array[1..I, 1..M] of float: BuyPrice;   % price to buy oil i in month m
float: SellPrice;

array[1..I] of bool: IsVegetable;

float: MaxVegRefiningPerMonth;
float: MaxNonVegRefiningPerMonth;

float: StorageSize;
float: StorageCost;

float: MaxHardness;
float: MinHardness;

array[1..I] of float: Hardness;

float: InitialAmount;          % initial storage amount for each oil type
float: MinUsage;               % if used, must use at least this much

array[1..I, 1..I] of int: Dependencies; % 1 => if i used then j used

set of int: OILS = 1..I;
set of int: MONTHS = 1..M;

% Decision variables
array[OILS, MONTHS] of var 0.0..StorageSize: buy;      % raw purchased in month
array[OILS, MONTHS] of var 0.0..StorageSize: refine;   % refined/used in month (equals amount of final product made from oil)
array[OILS, 0..M]  of var 0.0..StorageSize: store;     % end-of-month raw inventory

array[OILS, MONTHS] of var bool: used;                 % whether oil i is used in month m

% Initial and final inventory requirements
constraint forall(i in OILS) (
  store[i,0] = InitialAmount
);

constraint forall(i in OILS) (
  store[i,M] = InitialAmount
);

% Inventory balance: raw only can be stored
constraint forall(i in OILS, m in MONTHS) (
  store[i,m] = store[i,m-1] + buy[i,m] - refine[i,m]
);

% Storage capacity (total across oils)
constraint forall(m in 0..M) (
  sum(i in OILS)(store[i,m]) <= StorageSize
);

% Refining capacity by line type each month
constraint forall(m in MONTHS) (
  sum(i in OILS where IsVegetable[i])(refine[i,m]) <= MaxVegRefiningPerMonth
);
constraint forall(m in MONTHS) (
  sum(i in OILS where not IsVegetable[i])(refine[i,m]) <= MaxNonVegRefiningPerMonth
);

% Link used indicators to refine quantities, and enforce minimum usage if used
constraint forall(i in OILS, m in MONTHS) (
  refine[i,m] <= StorageSize * bool2int(used[i,m])
);
constraint forall(i in OILS, m in MONTHS) (
  refine[i,m] >= MinUsage * bool2int(used[i,m])
);

% At most three oils used in any month
constraint forall(m in MONTHS) (
  sum(i in OILS)(bool2int(used[i,m])) <= 3
);

% Dependencies: if i used then j used, whenever Dependencies[i,j] = 1
constraint forall(m in MONTHS, i in OILS, j in OILS where Dependencies[i,j] = 1) (
  bool2int(used[i,m]) <= bool2int(used[j,m])
);

% Hardness constraints on the blend each month.
% Apply only if there is production in that month.
array[MONTHS] of var 0.0..(MaxVegRefiningPerMonth + MaxNonVegRefiningPerMonth): totalProd =
  [sum(i in OILS)(refine[i,m]) | m in MONTHS];

constraint forall(m in MONTHS) (
  totalProd[m] = 0.0 \/
  (
    sum(i in OILS)(Hardness[i] * refine[i,m]) >= MinHardness * totalProd[m] /\
    sum(i in OILS)(Hardness[i] * refine[i,m]) <= MaxHardness * totalProd[m]
  )
);

% Objective: maximize profit = revenue - buying costs - storage costs
var float: revenue = sum(m in MONTHS)(SellPrice * totalProd[m]);
var float: buyCost = sum(i in OILS, m in MONTHS)(BuyPrice[i,m] * buy[i,m]);
var float: storageCost = sum(i in OILS, m in MONTHS)(StorageCost * store[i,m]);

var float: profit = revenue - buyCost - storageCost;

solve maximize profit;

output [
  "profit = ", show(profit), "\n",
  "revenue = ", show(revenue), "\n",
  "buyCost = ", show(buyCost), "\n",
  "storageCost = ", show(storageCost), "\n\n",
  "Month-by-month decisions:\n",
  concat([ "Month " ++ show(m) ++ ":\n"
           ++ "  totalProd = " ++ show(totalProd[m]) ++ "\n"
           ++ "  buy    = [" ++ concat([ if i=I then show(buy[i,m]) else show(buy[i,m]) ++ ", " endif | i in OILS ]) ++ "]\n"
           ++ "  refine = [" ++ concat([ if i=I then show(refine[i,m]) else show(refine[i,m]) ++ ", " endif | i in OILS ]) ++ "]\n"
           ++ "  used   = [" ++ concat([ if i=I then show(used[i,m]) else show(used[i,m]) ++ ", " endif | i in OILS ]) ++ "]\n"
           ++ "  store_end = [" ++ concat([ if i=I then show(store[i,m]) else show(store[i,m]) ++ ", " endif | i in OILS ]) ++ "]\n"
           ++ "\n"
         | m in MONTHS ])
];