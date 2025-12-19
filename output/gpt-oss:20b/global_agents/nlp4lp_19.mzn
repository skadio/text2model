include "globals.mzn";

int: M;                      % number of months
int: I;                      % number of oil types

array[1..M,1..I] of int: BuyPrice;      % price of oil i in month m
int: SellPrice;                        % selling price of final product
array[1..I] of bool: IsVegetable;      % true if oil i is vegetable
int: MaxVegetableRefiningPerMonth;      % max veg. oil refined per month
int: MaxNonVegetableRefiningPerMonth;   % max non‑veg. oil refined per month
int: StorageSize;                      % max total raw‑oil storage per month
int: StorageCost;                      % storage cost per ton per month
int: MaxHardness;                      % max allowed hardness
int: MinHardness;                      % min required hardness
array[1..I] of float: Hardness;        % hardness of each oil type
int: InitialAmount;                    % initial amount of each oil type

% Masks for vegetable / non‑vegetable oils
array[1..I] of int: vegMask = [if IsVegetable[i] then 1 else 0 endif | i in 1..I];
array[1..I] of int: nonVegMask = [1 - vegMask[i] | i in 1..I];

% Decision variables
array[1..M,1..I] of var int: buy;      % amount bought
array[1..M,1..I] of var int: store;    % amount stored at month end
array[1..M,1..I] of var int: refine;   % amount refined

var int: profit;                       % total profit

constraint
  % 1. Non‑negativity
  forall(m in 1..M, i in 1..I) (
    buy[m,i]    >= 0 /\
    store[m,i]  >= 0 /\
    refine[m,i] >= 0
  ) /\

  % 2. Inventory balance
  forall(i in 1..I) (
    store[1,i] == InitialAmount + buy[1,i] - refine[1,i]
  ) /\

  forall(m in 2..M, i in 1..I) (
    store[m,i] == store[m-1,i] + buy[m,i] - refine[m,i]
  ) /\

  % 3. Refining capacity limits
  forall(m in 1..M) (
    sum(i in 1..I)(vegMask[i]   * refine[m,i]) <= MaxVegetableRefiningPerMonth /\
    sum(i in 1..I)(nonVegMask[i] * refine[m,i]) <= MaxNonVegetableRefiningPerMonth
  ) /\

  % 4. Storage capacity per month
  forall(m in 1..M) (
    sum(i in 1..I) store[m,i] <= StorageSize
  ) /\

  % 5. Hardness constraints (weighted average)
  forall(m in 1..M) (
    sum(i in 1..I)(Hardness[i] * refine[m,i]) >= MinHardness * sum(i in 1..I)(refine[m,i]) /\
    sum(i in 1..I)(Hardness[i] * refine[m,i]) <= MaxHardness * sum(i in 1..I)(refine[m,i])
  ) /\

  % 6. Final storage equals initial storage
  forall(i in 1..I) (
    store[M,i] == InitialAmount
  ) /\

  % 7. Profit definition
  profit ==
    sum(m in 1..M)( SellPrice * sum(i in 1..I)( refine[m,i]) )   -- revenue
    - sum(m in 1..M)( sum(i in 1..I)( buy[m,i] * BuyPrice[m,i] ) )  -- buying cost
    - StorageCost * sum(m in 1..M)( sum(i in 1..I)( store[m,i] ) );  -- storage cost

solve maximize profit;

output [
  "Profit = ", show(profit), "\n",
  "Buy = ", show(buy), "\n",
  "Store = ", show(store), "\n",
  "Refine = ", show(refine), "\n"
];