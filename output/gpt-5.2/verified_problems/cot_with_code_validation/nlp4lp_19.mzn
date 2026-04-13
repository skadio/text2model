% Food manufacturing: buying, storing, refining and blending oils

% --------------------
% Parameters
% --------------------
int: M; % number of months
int: I; % number of oils

array[1..M, 1..I] of int: BuyPrice; % price of oil i in month m
int: SellPrice;

array[1..I] of bool: IsVegetable;

int: MaxVegetableRefiningPerMonth;
int: MaxNonVegetableRefiningPerMonth;

int: StorageSize;   % total storage capacity across all raw oils
int: StorageCost;   % per ton per month

float: MaxHardness;
float: MinHardness;
array[1..I] of float: Hardness;

int: InitialAmount; % initial stock for each oil (same for all oils)

% --------------------
% Decision variables
% --------------------
array[1..M, 1..I] of var 0..StorageSize: Buy;     % tons purchased
array[1..M, 1..I] of var 0..StorageSize: Refine;  % tons refined (used in final blend)
array[0..M, 1..I] of var 0..StorageSize: Store;   % tons of raw oil stored end of month m (m=0 initial)

% --------------------
% Constraints
% --------------------

% Initial and final inventory requirements (same amount as started with, per oil)
constraint forall(i in 1..I) (Store[0,i] = InitialAmount);
constraint forall(i in 1..I) (Store[M,i] = InitialAmount);

% Inventory balance
constraint forall(m in 1..M, i in 1..I) (
  Store[m,i] = Store[m-1,i] + Buy[m,i] - Refine[m,i]
);

% Total storage capacity (raw oil only)
constraint forall(m in 0..M) (
  sum(i in 1..I)(Store[m,i]) <= StorageSize
);

% Refining capacities by line
constraint forall(m in 1..M) (
  sum(i in 1..I where IsVegetable[i])(Refine[m,i]) <= MaxVegetableRefiningPerMonth
);
constraint forall(m in 1..M) (
  sum(i in 1..I where not IsVegetable[i])(Refine[m,i]) <= MaxNonVegetableRefiningPerMonth
);

% Hardness constraints on monthly blend:
% MinHardness <= (sum(h_i * x_i) / sum(x_i)) <= MaxHardness, unless total production is 0.
constraint forall(m in 1..M) (
  let {
    var int: TotalProd = sum(i in 1..I)(Refine[m,i]),
    var float: TotalHard = sum(i in 1..I)(Hardness[i] * int2float(Refine[m,i]))
  } in
    (TotalProd = 0) \/
    (MinHardness * int2float(TotalProd) <= TotalHard /\
     TotalHard <= MaxHardness * int2float(TotalProd))
);

% --------------------
% Objective: maximize profit
% --------------------
var int: Profit =
  sum(m in 1..M)(
      SellPrice * sum(i in 1..I)(Refine[m,i])
    - sum(i in 1..I)(BuyPrice[m,i] * Buy[m,i])
    - StorageCost * sum(i in 1..I)(Store[m,i])
  );

solve maximize Profit;

% --------------------
% Optional output
% --------------------
output [
  "Profit = ", show(Profit), "\n",
  "Buy:\n", show(Buy), "\n",
  "Refine:\n", show(Refine), "\n",
  "Store:\n", show(Store), "\n"
];