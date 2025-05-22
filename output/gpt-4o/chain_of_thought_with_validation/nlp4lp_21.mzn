% Parameters
int: M;
int: K;
int: I;

set of int: MACHINES  = 1..M;
set of int: PRODUCTS  = 1..K;
set of int: PERIODS   = 1..I;

array[MACHINES]              of int   : NumMachines;
array[PRODUCTS]              of float : Profit;
array[PRODUCTS, MACHINES]    of float : Time;
array[PERIODS, MACHINES]     of int   : Maintain;
array[PRODUCTS, PERIODS]     of int   : Limit;
float: StorePrice;
array[PRODUCTS]              of int   : KeepQuantity;
float: WorkHours;

% Derived constants
int: DAYS_PER_PERIOD = 24;
int: STORE_CAPACITY  = 100;
int: MAX_LIMIT       = max([ Limit[k,i] | k in PRODUCTS, i in PERIODS ]);

% Decision variables
array[PRODUCTS, PERIODS] of var 0..MAX_LIMIT      : Produce;
array[PRODUCTS, PERIODS] of var 0..MAX_LIMIT      : Sell;
array[PRODUCTS, PERIODS] of var 0..STORE_CAPACITY : Inventory;

% Machine-time capacity constraints
constraint
  forall(m in MACHINES, t in PERIODS) (
    sum(k in PRODUCTS) (
      Time[k,m] * int2float(Produce[k,t])
    )
    <=  int2float(NumMachines[m] - Maintain[t,m])
        * WorkHours
        * int2float(DAYS_PER_PERIOD)
  );

% Production upper bounds
constraint
  forall(k in PRODUCTS, t in PERIODS) (
    Produce[k,t] <= Limit[k,t]
  );

% Inventory balance
constraint
  forall(k in PRODUCTS) (
    Inventory[k,1] = Produce[k,1] - Sell[k,1]
  ) /\
  forall(k in PRODUCTS, t in 2..I) (
    Inventory[k,t] = Inventory[k,t-1] + Produce[k,t] - Sell[k,t]
  );

% Storage capacity
constraint
  forall(k in PRODUCTS, t in PERIODS) (
    Inventory[k,t] <= STORE_CAPACITY
  );

% Final stock requirement
constraint
  forall(k in PRODUCTS) (
    Inventory[k,I] >= KeepQuantity[k]
  );

% Objective: maximise total profit
var float: TotalProfit =
  sum(k in PRODUCTS, t in PERIODS) (
      Profit[k]  * int2float(Sell[k,t])
    - StorePrice * int2float(Inventory[k,t])
  );

solve maximize TotalProfit;