include "globals.mzn";

%========================
% Data (from .dzn)
%========================
int: M;                         % number of months
int: I;                         % number of oils

array[1..M, 1..I] of int: BuyPrice;  % price to buy oil i in month m
int: SellPrice;                 % selling price per ton of final product

array[1..I] of bool: IsVegetable;

int: MaxVegetableRefiningPerMonth;
int: MaxNonVegetableRefiningPerMonth;

int: StorageSize;               % total storage capacity (tons of raw oil)
int: StorageCost;               % cost per ton per month in storage

float: MaxHardness;
float: MinHardness;
array[1..I] of float: Hardness;

int: InitialAmount;             % initial raw inventory per oil type (tons)

%========================
% Modeling choices / scaling
%========================
% Use integer tons; hardness is handled by multiplying inequalities to avoid division.
% We scale hardness by 10^HScale to make it integral (handles inputs like 8.8, 6.1, ...).
int: HScale = 10;
array[1..I] of int: HardInt = [ round(Hardness[i] * HScale) | i in 1..I ];
int: MinHardInt = round(MinHardness * HScale);
int: MaxHardInt = round(MaxHardness * HScale);

int: MaxCap = max(StorageSize, MaxVegetableRefiningPerMonth + MaxNonVegetableRefiningPerMonth);

%========================
% Decision variables
%========================
% buy[m,i]   = tons of raw oil i purchased in month m
% use[m,i]   = tons of raw oil i refined/used in month m
% stock[m,i] = end-of-month raw stock of oil i after buying and using in month m
array[1..M, 1..I] of var 0..StorageSize: buy;
array[1..M, 1..I] of var 0..MaxCap:      use;
array[0..M, 1..I] of var 0..StorageSize: stock;

% total production each month (tons refined = tons final product)
array[1..M] of var 0..(MaxVegetableRefiningPerMonth + MaxNonVegetableRefiningPerMonth): prod;

%========================
% Constraints
%========================

% Initial stock: same amount for each oil type at time 0
constraint forall(i in 1..I)( stock[0,i] = InitialAmount );

% Inventory balance: end stock = start stock + buy - use
constraint forall(m in 1..M, i in 1..I)(
  stock[m,i] = stock[m-1,i] + buy[m,i] - use[m,i]
);

% Cannot use more than available within the month
constraint forall(m in 1..M, i in 1..I)(
  use[m,i] <= stock[m-1,i] + buy[m,i]
);

% Storage capacity (raw only): total stock at end of each month limited
constraint forall(m in 1..M)(
  sum(i in 1..I)(stock[m,i]) <= StorageSize
);

% Refining capacities by line type
constraint forall(m in 1..M)(
  sum(i in 1..I where IsVegetable[i])(use[m,i]) <= MaxVegetableRefiningPerMonth
);
constraint forall(m in 1..M)(
  sum(i in 1..I where not IsVegetable[i])(use[m,i]) <= MaxNonVegetableRefiningPerMonth
);

% Production definition
constraint forall(m in 1..M)(
  prod[m] = sum(i in 1..I)(use[m,i])
);

% Hardness constraints on blended final product each month.
% If prod[m] = 0, these are trivially satisfied.
constraint forall(m in 1..M)(
  sum(i in 1..I)(HardInt[i] * use[m,i]) >= MinHardInt * prod[m]
);
constraint forall(m in 1..M)(
  sum(i in 1..I)(HardInt[i] * use[m,i]) <= MaxHardInt * prod[m]
);

% End condition: end-of-horizon stock equals initial stock for each oil type
constraint forall(i in 1..I)( stock[M,i] = stock[0,i] );

%========================
% Objective: maximize profit
% Profit = revenue - buying costs - storage costs
% Storage cost charged per ton stored per month (end-of-month stock).
%========================
var int: revenue = SellPrice * sum(m in 1..M)(prod[m]);
var int: buy_cost = sum(m in 1..M, i in 1..I)(BuyPrice[m,i] * buy[m,i]);
var int: storage_cost = StorageCost * sum(m in 1..M, i in 1..I)(stock[m,i]);

var int: profit = revenue - buy_cost - storage_cost;

solve maximize profit;

%========================
% Output
%========================
output [
  "Profit = ", show(profit), "\n",
  "Revenue = ", show(revenue), "  BuyCost = ", show(buy_cost), "  StorageCost = ", show(storage_cost), "\n\n",
  "Buy (month x oil):\n", show(buy), "\n\n",
  "Use/Refine (month x oil):\n", show(use), "\n\n",
  "End Stock (month 0..M x oil):\n", show(stock), "\n\n",
  "Production per month:\n", show(prod), "\n"
];