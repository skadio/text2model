include "float.mzn";

int: M;
int: K;
int: I;

set of int: MACH = 1..M;
set of int: PROD = 1..K;
set of int: PER  = 1..I;

array[MACH] of int: NumMachines;
array[PROD] of float: Profit;
array[PROD, MACH] of float: Time;
array[PER, MACH] of int: Maintain;
array[PROD, PER] of int: Limit;
float: StorePrice;
array[PROD] of int: KeepQuantity;
float: WorkHours;

% Assumptions per statement:
int: DaysPerMonth = 24;
float: HoursPerDay = WorkHours;
float: HoursPerMonth = HoursPerDay * int2float(DaysPerMonth);

% Capacity (in hours) for each machine type and month after maintenance
array[PER, MACH] of float: Capacity =
  array2d(PER, MACH,
    [ max(0.0, (int2float(NumMachines[m] - Maintain[i,m])) * HoursPerMonth)
      | i in PER, m in MACH ]);

% Decision variables
array[PROD, PER] of var int: Make;   % manufactured in month i
array[PROD, PER] of var int: Sell;   % sold in month i
array[PROD, PER] of var int: Stock;  % stock at end of month i

% Bounds and feasibility
constraint forall(k in PROD, i in PER) (Make[k,i] >= 0 /\ Sell[k,i] >= 0 /\ Stock[k,i] >= 0);

% Production limits per product/month
constraint forall(k in PROD, i in PER) (Make[k,i] <= Limit[k,i]);

% Storage limit of 100 units per product
constraint forall(k in PROD, i in PER) (Stock[k,i] <= 100);

% Inventory balance (start with zero stock)
constraint forall(k in PROD) (
  Stock[k,1] = Make[k,1] - Sell[k,1]
);
constraint forall(k in PROD, i in 2..I) (
  Stock[k,i] = Stock[k,i-1] + Make[k,i] - Sell[k,i]
);

% Cannot sell more than available in the month
constraint forall(k in PROD) (Sell[k,1] <= Make[k,1]);
constraint forall(k in PROD, i in 2..I) (Sell[k,i] <= Stock[k,i-1] + Make[k,i]);

% Minimum stock to keep at end of each month (subsequent months)
constraint forall(k in PROD, i in PER) (Stock[k,i] >= KeepQuantity[k]);

% Machine capacity constraints per month
constraint forall(i in PER, m in MACH) (
  sum(k in PROD) ( Time[k,m] * int2float(Make[k,i]) ) <= Capacity[i,m]
);

% Objective: maximize profit from sales minus storage costs (charged per unit held at end of month)
var float: TotalProfit =
  sum(k in PROD, i in PER) ( Profit[k] * int2float(Sell[k,i]) )
  - StorePrice * sum(k in PROD, i in PER) ( int2float(Stock[k,i]) );

solve maximize TotalProfit;

output [
  "TotalProfit = ", show(TotalProfit), "\n",
  "Make = ", show(Make), "\n",
  "Sell = ", show(Sell), "\n",
  "Stock = ", show(Stock), "\n"
];