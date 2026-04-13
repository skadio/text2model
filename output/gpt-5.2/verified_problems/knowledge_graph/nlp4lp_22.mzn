include "globals.mzn";

int: M;                      % machine types
int: K;                      % product types
int: I;                      % time periods (months)

array[1..M] of int: NumMachines;
array[1..K] of float: Profit;
array[1..K, 1..M] of float: Time;         % hours per unit on machine m for product k
array[1..I, 1..M] of int: Downtime;       % number of machines of type m down in month i
array[1..K, 1..I] of int: Limit;          % max production per product per month
float: StorePrice;                        % cost per unit held per month
int: KeepQuantity;                        % minimum stock at end of each month (except month 1)
float: WorkHours;                         % hours per shift per day

% Fixed calendar assumptions
int: DaysPerMonth = 24;
int: ShiftsPerDay = 2;

% Available machine-hours per month, per machine type
array[1..I, 1..M] of float: Capacity =
  array2d(1..I, 1..M,
    [ (WorkHours * ShiftsPerDay * DaysPerMonth) *
      int2float(max(0, NumMachines[m] - Downtime[i,m]))
      | i in 1..I, m in 1..M ]);

% Decision variables
array[1..K, 1..I] of var 0..10000: Make;     % manufactured in month i
array[1..K, 1..I] of var 0..10000: Sell;     % sold in month i
array[1..K, 1..I] of var 0..100: Stock;      % end-of-month inventory (max 100)

% Production limits
constraint forall(k in 1..K, i in 1..I) (
  Make[k,i] <= Limit[k,i]
);

% Machine capacity constraints
constraint forall(i in 1..I, m in 1..M) (
  sum(k in 1..K) ( Time[k,m] * int2float(Make[k,i]) ) <= Capacity[i,m]
);

% Inventory balance (start with zero stock)
constraint forall(k in 1..K) (
  Stock[k,1] = Make[k,1] - Sell[k,1]
);
constraint forall(k in 1..K, i in 2..I) (
  Stock[k,i] = Stock[k,i-1] + Make[k,i] - Sell[k,i]
);

% Cannot sell more than available
constraint forall(k in 1..K, i in 1..I) (
  Sell[k,i] <= (if i=1 then Make[k,1] else Stock[k,i-1] + Make[k,i] endif)
);

% Minimum stock to keep at end of subsequent months (i >= 2)
constraint forall(k in 1..K, i in 2..I) (
  Stock[k,i] >= KeepQuantity
);

% Objective: maximize total profit from sales minus storage costs
var float: TotalProfit =
  sum(k in 1..K, i in 1..I) ( Profit[k] * int2float(Sell[k,i]) )
  - StorePrice * sum(k in 1..K, i in 1..I) ( int2float(Stock[k,i]) );

solve maximize TotalProfit;

output [
  "TotalProfit=", show(TotalProfit), "\n",
  "Make=\n", show(Make), "\n",
  "Sell=\n", show(Sell), "\n",
  "Stock=\n", show(Stock), "\n"
];