% Parameters
int: M;
int: K;
int: I;

set of int: MACH = 1..M;
set of int: PROD = 1..K;
set of int: PER  = 1..I;

array[MACH] of int: NumMachines;
array[PROD] of int: Profit;
array[PROD, MACH] of float: Time;
array[MACH] of int: Downtime;
array[PROD, PER] of int: Limit;

float: StorePrice;
int: KeepQuantity;
float: WorkHours;

% Derived constants
int: DaysPerMonth = 24;
int: ShiftsPerDay = 2;
float: HoursPerMonth = WorkHours * float(DaysPerMonth * ShiftsPerDay);

% Upper bounds for production per product across months (used for variable bounds)
array[PROD] of int: MaxLimit = [ max(t in PER)(Limit[p,t]) | p in PROD ];
int: StockCap = 100;

% Variables
array[PROD, PER] of var 0..max(MaxLimit): Make;
array[PROD, PER] of var 0..max(MaxLimit): Sell;
array[PROD, PER] of var 0..StockCap: Stock;

var float: TotalProfit;

% Constraints
% Production and sales cannot exceed monthly limits
constraint forall(p in PROD, t in PER) (
  Make[p,t] <= Limit[p,t] /\
  Sell[p,t] <= Limit[p,t]
);

% Inventory balance (start with zero stock)
constraint forall(p in PROD) (
  Stock[p,1] = Make[p,1] - Sell[p,1]
);
constraint forall(p in PROD, t in 2..I) (
  Stock[p,t] = Stock[p,t-1] + Make[p,t] - Sell[p,t]
);

% Cannot sell more than available (redundant with balance + Stock >= 0, but explicit)
constraint forall(p in PROD, t in PER) (
  Sell[p,t] <= Make[p,t] + (if t = 1 then 0 else Stock[p,t-1] endif)
);

% Storage capacity and minimum required stock at end of subsequent months
constraint forall(p in PROD, t in PER) (
  Stock[p,t] <= StockCap
);
constraint forall(p in PROD, t in 2..I) (
  Stock[p,t] >= KeepQuantity
);

% Machine time capacity per month with downtime
constraint forall(m in MACH, t in PER) (
  sum(p in PROD)( Time[p,m] * float(Make[p,t]) )
  <= HoursPerMonth * float(NumMachines[m] - Downtime[m])
);

% Objective
constraint
  TotalProfit =
    sum(t in PER, p in PROD)( float(Profit[p]) * float(Sell[p,t]) )
    - StorePrice * sum(t in PER, p in PROD)( float(Stock[p,t]) );

solve maximize TotalProfit;