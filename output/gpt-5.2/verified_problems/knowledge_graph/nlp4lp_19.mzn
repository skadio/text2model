include "globals.mzn";

int: M;
int: I;

set of int: Months = 1..M;
set of int: Oils   = 1..I;

array[Months, Oils] of float: BuyPrice;   % month, oil
float: SellPrice;

array[Oils] of bool: IsVegetable;

int: MaxVegetableRefiningPerMonth;
int: MaxNonVegetableRefiningPerMonth;

int: StorageSize;
float: StorageCost;

float: MaxHardness;
float: MinHardness;
array[Oils] of float: Hardness;

int: InitialAmount;

% Decision variables
array[Months, Oils] of var 0..StorageSize: buy;      % tons of raw oil purchased
array[Months, Oils] of var 0..StorageSize: refine;   % tons of raw oil refined (and blended into product)
array[0..M, Oils] of var 0..StorageSize: stock;      % tons of raw oil in storage at end of each month

% Initial and final stock requirements
constraint forall(o in Oils) (
  stock[0,o] = InitialAmount /\
  stock[M,o] = InitialAmount
);

% Material balance and storage capacity
constraint forall(m in Months, o in Oils) (
  stock[m,o] = stock[m-1,o] + buy[m,o] - refine[m,o]
);

constraint forall(m in 0..M) (
  sum(o in Oils)(stock[m,o]) <= StorageSize
);

% Refining capacity by line (veg vs non-veg) per month
constraint forall(m in Months) (
  sum(o in Oils where IsVegetable[o])(refine[m,o]) <= MaxVegetableRefiningPerMonth
);

constraint forall(m in Months) (
  sum(o in Oils where not IsVegetable[o])(refine[m,o]) <= MaxNonVegetableRefiningPerMonth
);

% Hardness constraints on final product each month (if any production that month)
constraint forall(m in Months) (
  let { var int: total = sum(o in Oils)(refine[m,o]) } in
    (total = 0) \/
    ( sum(o in Oils)(Hardness[o] * refine[m,o]) >= MinHardness * total /\
      sum(o in Oils)(Hardness[o] * refine[m,o]) <= MaxHardness * total )
);

% Objective: maximize profit = revenue - purchase cost - storage cost
var float: revenue =
  SellPrice * sum(m in Months, o in Oils)(refine[m,o]);

var float: purchase_cost =
  sum(m in Months, o in Oils)(BuyPrice[m,o] * buy[m,o]);

var float: storage_cost =
  StorageCost * sum(m in Months, o in Oils)(stock[m,o]);

var float: profit = revenue - purchase_cost - storage_cost;

solve maximize profit;

output [
  "profit=", show(profit), "\n",
  "revenue=", show(revenue), " purchase_cost=", show(purchase_cost), " storage_cost=", show(storage_cost), "\n\n",
  "buy (month x oil):\n", show(buy), "\n\n",
  "refine (month x oil):\n", show(refine), "\n\n",
  "stock (0..M x oil):\n", show(stock), "\n"
];