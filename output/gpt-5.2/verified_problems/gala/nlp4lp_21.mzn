% Production / inventory planning to maximize profit
% Data is provided via .dzn

int: M;                        % machine types
int: K;                        % product types
int: I;                        % time periods (months)

array[1..M] of int: NumMachines;
array[1..K] of float: Profit;                 % profit per unit sold
array[1..K, 1..M] of float: Time;             % hours required per unit on machine m
array[1..I, 1..M] of int: Maintain;            % machines down in period i for type m
array[1..K, 1..I] of int: Limit;               % production upper bound per product per period

float: StorePrice;                             % storage cost per unit per month
array[1..K] of int: KeepQuantity;              % minimum ending inventory requirement (end of months 2..I)
float: WorkHours;                              % hours/day

% Assumptions from statement
int: DaysPerMonth = 24;
int: MaxStore = 100;                           % max inventory per product

% Available capacity in hours for each machine type and month
array[1..I, 1..M] of float: Capacity =
  array2d(1..I, 1..M,
    [ WorkHours * float(DaysPerMonth) * float(max(0, NumMachines[m] - Maintain[i,m]))
      | i in 1..I, m in 1..M ]);

% Decision variables
array[1..K, 1..I] of var 0..max(Limit): make;  % produce
array[1..K, 1..I] of var 0..1000000: sell;     % sell (bounded by availability via balance)
array[1..K, 0..I] of var 0..MaxStore: stock;   % end-of-period inventory, stock[k,0]=0

% Initial stock
constraint forall(k in 1..K)( stock[k,0] = 0 );

% Inventory balance: stock_{i} = stock_{i-1} + make_{i} - sell_{i}
constraint forall(k in 1..K, i in 1..I)(
  stock[k,i] = stock[k,i-1] + make[k,i] - sell[k,i]
);

% Production limits per product and month
constraint forall(k in 1..K, i in 1..I)(
  make[k,i] <= Limit[k,i]
);

% Storage capacity (already enforced by domain 0..MaxStore) but keep explicit
constraint forall(k in 1..K, i in 1..I)(
  stock[k,i] <= MaxStore
);

% Minimum ending stock requirement from end of month 2 onwards (as stated)
constraint forall(k in 1..K, i in 2..I)(
  stock[k,i] >= KeepQuantity[k]
);

% Machine capacity constraints per month and machine type
constraint forall(i in 1..I, m in 1..M)(
  sum(k in 1..K)( Time[k,m] * int2float(make[k,i]) ) <= Capacity[i,m]
);

% Objective: maximize total profit from sales minus storage costs for inventory carried each month
var float: total_profit =
  sum(k in 1..K, i in 1..I)( Profit[k] * int2float(sell[k,i]) )
  - StorePrice * sum(k in 1..K, i in 1..I)( int2float(stock[k,i]) );

solve maximize total_profit;

output [
  "Total profit = ", show(total_profit), "\n\n",
  "Make (K x I) =\n", show(make), "\n\n",
  "Sell (K x I) =\n", show(sell), "\n\n",
  "Stock end-of-month (K x I) =\n",
  show(array2d(1..K,1..I,[stock[k,i] | k in 1..K, i in 1..I])), "\n"
];