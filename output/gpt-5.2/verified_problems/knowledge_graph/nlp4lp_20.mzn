include "float.mzn";

int: I;
int: M;

set of int: Oils = 1..I;
set of int: Months = 1..M;

array[Oils, Months] of float: BuyPrice;  % price per ton
float: SellPrice;                        % revenue per ton of final product

array[Oils] of bool: IsVegetable;

int: MaxVegRefiningPerMonth;
int: MaxNonVegRefiningPerMonth;

int: StorageSize;        % max total raw oil in storage (tons)
float: StorageCost;      % cost per ton per month stored

float: MaxHardness;
float: MinHardness;
array[Oils] of float: Hardness;

int: InitialAmount;      % initial storage for each oil type (tons)
int: MinUsage;           % if used in a month, at least this amount is refined

array[Oils, Oils] of bool: Dependencies; % if Dependencies[i,j] then use(i)->use(j)

% ---------------- Decisions ----------------
array[Oils, Months] of var float: buy;        % tons purchased in month
array[Oils, Months] of var float: refine;     % tons refined/used in product in month
array[Oils, 0..M] of var float: store;        % tons of raw oil held at end of month

array[Oils, Months] of var bool: use;         % whether oil i is used in month m

% ---------------- Bounds & Domains ----------------
constraint forall(i in Oils, m in Months) (buy[i,m] >= 0.0);
constraint forall(i in Oils, m in Months) (refine[i,m] >= 0.0);
constraint forall(i in Oils, m in 0..M) (store[i,m] >= 0.0);

% Initial and final inventory requirements
constraint forall(i in Oils) (store[i,0] = float(InitialAmount));
constraint forall(i in Oils) (store[i,M] = float(InitialAmount));

% Inventory flow: end-of-month storage = previous storage + bought - refined
constraint forall(i in Oils, m in Months) (
  store[i,m] = store[i,m-1] + buy[i,m] - refine[i,m]
);

% Storage capacity (total raw oil stored at any month end)
constraint forall(m in 0..M) (
  sum(i in Oils)(store[i,m]) <= float(StorageSize)
);

% Refining capacities per month by type
constraint forall(m in Months) (
  sum(i in Oils where IsVegetable[i])(refine[i,m]) <= float(MaxVegRefiningPerMonth)
);
constraint forall(m in Months) (
  sum(i in Oils where not IsVegetable[i])(refine[i,m]) <= float(MaxNonVegRefiningPerMonth)
);

% Link refine and use with minimum usage and at most three oils per month
constraint forall(i in Oils, m in Months) (
  refine[i,m] <= 1.0e9 * bool2int(use[i,m])
);
constraint forall(i in Oils, m in Months) (
  refine[i,m] >= float(MinUsage) * bool2int(use[i,m])
);

constraint forall(m in Months) (
  sum(i in Oils)(bool2int(use[i,m])) <= 3
);

% Dependencies: if oil i is used, then each required oil j must also be used
constraint forall(m in Months, i in Oils, j in Oils where Dependencies[i,j]) (
  bool2int(use[i,m]) <= bool2int(use[j,m])
);

% Hardness constraints (weighted average)
% Enforced only if there is production; if no production in a month, hardness is irrelevant.
constraint forall(m in Months) (
  let {
    var float: total_prod = sum(i in Oils)(refine[i,m]),
    var float: weighted = sum(i in Oils)(Hardness[i] * refine[i,m])
  } in
    (total_prod = 0.0) \/
    (weighted >= MinHardness * total_prod /\ weighted <= MaxHardness * total_prod)
);

% ---------------- Objective: maximize profit ----------------
var float: revenue =
  sum(m in Months)(SellPrice * sum(i in Oils)(refine[i,m]));

var float: purchase_cost =
  sum(m in Months, i in Oils)(BuyPrice[i,m] * buy[i,m]);

% Storage cost per ton per month stored (charge for end-of-month inventory for months 1..M)
var float: holding_cost =
  sum(m in 1..M, i in Oils)(StorageCost * store[i,m]);

var float: profit = revenue - purchase_cost - holding_cost;

solve maximize profit;

output [
  "profit = ", show(profit), "\n",
  "revenue = ", show(revenue), "\n",
  "purchase_cost = ", show(purchase_cost), "\n",
  "holding_cost = ", show(holding_cost), "\n\n",
  "buy =\n", show(buy), "\n\n",
  "refine =\n", show(refine), "\n\n",
  "store =\n", show(store), "\n\n",
  "use =\n", show(use), "\n"
];