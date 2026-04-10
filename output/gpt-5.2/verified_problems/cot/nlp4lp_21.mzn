% Parameters
int: M;
int: K;
int: I;

set of int: MACHINES = 1..M;
set of int: PRODUCTS = 1..K;
set of int: PERIODS = 1..I;

array[MACHINES] of int: NumMachines;
array[PRODUCTS] of int: Profit;
array[PRODUCTS, MACHINES] of float: Time;
array[PERIODS, MACHINES] of int: Maintain;
array[PRODUCTS, PERIODS] of int: Limit;

float: StorePrice;
array[PRODUCTS] of int: KeepQuantity;
float: WorkHours;

% fixed calendar assumptions
int: DaysPerMonth = 24;
int: WorkDaysPerWeek = 6;

% Variables
array[PRODUCTS, PERIODS] of var int: Make;
array[PRODUCTS, PERIODS] of var int: Sell;
array[PRODUCTS, PERIODS] of var int: Stock;

var float: TotalProfit;

% Constraints
constraint forall(k in PRODUCTS, i in PERIODS) (
  Make[k,i] >= 0 /\ Sell[k,i] >= 0 /\ Stock[k,i] >= 0
);

% storage capacity limit: at most 100 units of each product
constraint forall(k in PRODUCTS, i in PERIODS) (
  Stock[k,i] <= 100
);

% production limits per product and period
constraint forall(k in PRODUCTS, i in PERIODS) (
  Make[k,i] <= Limit[k,i]
);

% cannot sell more than available (make + previous stock)
constraint forall(k in PRODUCTS) (
  Sell[k,1] <= Make[k,1]
);
constraint forall(k in PRODUCTS, i in 2..I) (
  Sell[k,i] <= Make[k,i] + Stock[k,i-1]
);

% inventory balance (start with zero stock)
constraint forall(k in PRODUCTS) (
  Stock[k,1] = Make[k,1] - Sell[k,1]
);
constraint forall(k in PRODUCTS, i in 2..I) (
  Stock[k,i] = Stock[k,i-1] + Make[k,i] - Sell[k,i]
);

% minimum stock to keep at end of each subsequent month (i >= 2)
constraint forall(k in PRODUCTS, i in 2..I) (
  Stock[k,i] >= KeepQuantity[k]
);

% machine capacity constraints per period
% Available hours per machine type = (NumMachines - Maintain) * (WorkDaysPerWeek/7) * DaysPerMonth * WorkHours
constraint forall(i in PERIODS, m in MACHINES) (
  sum(k in PRODUCTS) ( Time[k,m] * int2float(Make[k,i]) )
  <=
  int2float(NumMachines[m] - Maintain[i,m]) * (int2float(WorkDaysPerWeek) / 7.0) * int2float(DaysPerMonth) * WorkHours
);

% define objective expression
constraint
  TotalProfit =
    sum(k in PRODUCTS, i in PERIODS) ( int2float(Profit[k]) * int2float(Sell[k,i]) )
    - StorePrice * sum(k in PRODUCTS, i in PERIODS) ( int2float(Stock[k,i]) );

% Objective
solve maximize TotalProfit;