int: M;
int: I;

array[1..M, 1..I] of float: BuyPrice; % month m, oil i
float: SellPrice;

array[1..I] of bool: IsVegetable;

float: MaxVegetableRefiningPerMonth;
float: MaxNonVegetableRefiningPerMonth;

float: StorageSize;
float: StorageCost;

float: MaxHardness;
float: MinHardness;

array[1..I] of float: Hardness;

float: InitialAmount;

set of int: Months = 1..M;
set of int: Oils = 1..I;

% Decision variables (tons)
array[Months, Oils] of var float: Buy;
array[Months, Oils] of var float: Refine;     % refined/used in final product
array[0..M, Oils] of var float: Store;        % raw oil inventory at end of each month
array[Months] of var float: Produce;          % total refined product (tons) per month

constraint forall(i in Oils) (
  Store[0,i] = InitialAmount
);

constraint forall(m in Months, i in Oils) (
  Buy[m,i] >= 0.0 /\ Refine[m,i] >= 0.0 /\ Store[m,i] >= 0.0
);

% Inventory balance: raw oil only
constraint forall(m in Months, i in Oils) (
  Store[m,i] = Store[m-1,i] + Buy[m,i] - Refine[m,i]
);

% End condition: finish with same inventory as initial
constraint forall(i in Oils) (
  Store[M,i] = InitialAmount
);

% Storage capacity (total raw oil)
constraint forall(m in 0..M) (
  sum(i in Oils)(Store[m,i]) <= StorageSize
);

% Refining capacity by type
constraint forall(m in Months) (
  sum(i in Oils where IsVegetable[i]) (Refine[m,i]) <= MaxVegetableRefiningPerMonth
);

constraint forall(m in Months) (
  sum(i in Oils where not IsVegetable[i]) (Refine[m,i]) <= MaxNonVegetableRefiningPerMonth
);

% Production equals total refined amount (no loss)
constraint forall(m in Months) (
  Produce[m] = sum(i in Oils)(Refine[m,i])
);

% Hardness constraints (weighted average) per month
% Implemented without division: MinHardness*Produce <= sum(h_i * refine_i) <= MaxHardness*Produce
constraint forall(m in Months) (
  sum(i in Oils)(Hardness[i] * Refine[m,i]) <= MaxHardness * Produce[m]
);

constraint forall(m in Months) (
  sum(i in Oils)(Hardness[i] * Refine[m,i]) >= MinHardness * Produce[m]
);

% Objective: maximize profit = revenue - buying cost - storage cost
var float: Revenue = sum(m in Months)(SellPrice * Produce[m]);
var float: BuyingCost = sum(m in Months, i in Oils)(BuyPrice[m,i] * Buy[m,i]);
var float: HoldingCost = sum(m in Months, i in Oils)(StorageCost * Store[m,i]); % cost per ton per month held

var float: Profit = Revenue - BuyingCost - HoldingCost;

solve maximize Profit;

output [
  "Profit = ", show(Profit), "\n",
  "Revenue = ", show(Revenue), "\n",
  "BuyingCost = ", show(BuyingCost), "\n",
  "HoldingCost = ", show(HoldingCost), "\n\n",
  "Buy (m x i):\n", show(Buy), "\n\n",
  "Refine (m x i):\n", show(Refine), "\n\n",
  "Store (end of month, 0..M x i):\n", show(Store), "\n\n",
  "Produce (per month):\n", show(Produce), "\n"
];